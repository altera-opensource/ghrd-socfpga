#------------------------------------------------------------------------------
#
# Copyright (c) 2008 - 2010, Apple Inc. All rights reserved.<BR>
# Copyright (c) 2011 - 2014, ARM Limited. All rights reserved.
# Copyright (c) 2016, Linaro Limited. All rights reserved.
#
# License changed to “BSD 2-Clause Plus Patent” License.
#
# This program and the accompanying materials
# are licensed and made available under the terms and conditions of the BSD License
# which accompanies this distribution.  The full text of the license may be found at
# http://opensource.org/licenses/bsd-license.php
#
# THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
# WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
#
# Cache maintainence code is reference from UEFI EDK2 ArmPkg\Library\ArmLib\AArch64\AArch64Support.S
#------------------------------------------------------------------------------
	.equ STACK_BASE_ADDR,         0xffe10000	
	.equ MAILBOX_BASE_ADDR,       0xffa30000
	.equ MAILBOX_COE_INT_FLAG,    0x1
	.equ MAILBOX_RIE_INT_FLAG,    0x2
	.equ MAILBOX_UAE_INT_FLAG,    0x100
	.equ MAILBOX_SEND_CMD,        0x11000048 //0x48 is hps_wipe_done
	.equ OFFSET_CIN, 	      0x0
	.equ OFFSET_ROUT,	      0x4
	.equ OFFSET_URG,	      0x8
	.equ OFFSET_INT_FLAG,	      0xc
	.equ OFFSET_COUT, 	      0x20
	.equ OFFSET_RIN,	      0x24
	.equ OFFSET_STATUS,	      0x2c
	.equ OFFSET_CMD_BUFFER,       0x40     
	.equ OFFSET_RESP_BUFFER,      0xc0
	.equ OFFSET_DOOR_BELL_TO_SDM, 0x400
	.equ OFFSET_DOOR_BELL_TO_HPS, 0x480
        .equ TIMEOUT,                 0xc350
	
	.text
	.globl	_start
	.set CTRL_C_BIT,     (1 << 2)
	.set CTRL_I_BIT,     (1 << 12)
	.set CTRL_M_BIT,     (1 << 0)
	.set DAIF_FIQ_BIT,   (1 << 0)
	.set DAIF_IRQ_BIT,   (1 << 1)
	.set DAIF_ABORT_BIT, (1 << 2)
	.set DAIF_DEBUG_BIT, (1 << 3)
	.set DAIF_UA_BIT,    (1 << 8)
	.set DAIF_INT_BITS,  (DAIF_FIQ_BIT | DAIF_IRQ_BIT)
	.set DAIF_ALL,       (DAIF_DEBUG_BIT | DAIF_ABORT_BIT | DAIF_INT_BITS)
	
_start:
       
	bl ArmSetStackPointer
	bl ArmCleanDataCache
	bl ArmDisableDataCache
	bl ArmInvalidateDataCache
	bl ArmDisableInstructionCache
	bl ArmInvalidateInstructionCache
	bl ArmDisableMmu
	bl InformMailbox
loop:	b  loop

ArmSetStackPointer:
        ldr x0,=STACK_BASE_ADDR
	mov sp,x0
	ret
	
ArmInvalidateInstructionCache:
	ic      iallu       // Invalidate entire instruction cache
	dsb     sy
	isb
	ret

ArmCleanDataCache:
	str x30,[sp,#-16]! //Save LR to [SP-16]
	bl  ArmDrainWriteBuffer
	adr x0, ArmCleanDataCacheEntryBySetWay
	bl  AArch64DataCacheOperation
	ldr x30,[sp],#16  //Load [SP] to LR
	ret

ArmCleanDataCacheEntryBySetWay:
	dc    csw, x0     // Clean this line
	dsb   sy
	isb
	ret

ArmInvalidateDataCache:
	str x30,[sp,#-16]!
	bl  ArmDrainWriteBuffer
	adr x0, ArmInvalidateDataCacheEntryBySetWay
	bl  AArch64DataCacheOperation
	ldr x30,[sp],#16
	ret

ArmInvalidateDataCacheEntryBySetWay:
	dc    isw, x0    // Invalidate this line
	dsb   sy
	isb
	ret

ArmDrainWriteBuffer:
	dsb   sy
	ret

AArch64DataCacheOperation:
        str     x30,[sp,#-16]!
 	mov	x20, x0
	bl	ArmGetInterruptState
	uxtb	w19, w0
	bl	ArmDisableInterrupts
	mov	x0, x20
	bl	AArch64AllDataCachesOperation
	bl	ArmDrainWriteBuffer
	cbnz    w19, ArmEnableInterrupts
	ldr     x30,[sp],#16
	ret

ArmGetInterruptState:
	mrs     x0, daif
	tst     w0, #DAIF_IRQ_BIT   // Check if IRQ is enabled. Enabled if 0.
	mov     w0, #0
	mov     w1, #1
	csel    w0, w1, w0, ne
	ret

ArmDisableInterrupts:
	msr   daifset, #DAIF_INT_BITS
	isb
	ret

ArmEnableInterrupts:
	msr   daifclr, #DAIF_INT_BITS
	isb
	ret

AArch64AllDataCachesOperation:
// We can use regs 0-7 and 9-15 without having to save/restore.
// Save our link register on the stack. - The stack must always be quad-word aligned
    str   x30, [sp, #-16]!
    mov   x1, x0                  // Save Function call in x1
    mrs   x6, clidr_el1           // Read EL1 CLIDR
    and   x3, x6, #0x7000000      // Mask out all but Level of Coherency (LoC)
    lsr   x3, x3, #23             // Left align cache level value - the level is shifted by 1 to the
                                  // right to ease the access to CSSELR and the Set/Way operation.
    cbz   x3, L_Finished          // No need to clean if LoC is 0
    mov   x10, #0                 // Start clean at cache level 0
    
Loop1:
    add   x2, x10, x10, lsr #1    // Work out 3x cachelevel for cache info
    lsr   x12, x6, x2             // bottom 3 bits are the Cache type for this level
    and   x12, x12, #7            // get those 3 bits alone
    cmp   x12, #2                 // what cache at this level?
    b.lt  L_Skip                  // no cache or only instruction cache at this level
    msr   csselr_el1, x10         // write the Cache Size selection register with current level (CSSELR)
    isb                           // isb to sync the change to the CacheSizeID reg
    mrs   x12, ccsidr_el1         // reads current Cache Size ID register (CCSIDR)
    and   x2, x12, #0x7           // extract the line length field
    add   x2, x2, #4              // add 4 for the line length offset (log2 16 bytes)
    mov   x4, #0x400
    sub   x4, x4, #1
    and   x4, x4, x12, lsr #3     // x4 is the max number on the way size (right aligned)
    clz   w5, w4                  // w5 is the bit position of the way size increment
    mov   x7, #0x00008000
    sub   x7, x7, #1
    and   x7, x7, x12, lsr #13    // x7 is the max number of the index size (right aligned)

Loop2:
    mov   x9, x4                  // x9 working copy of the max way size (right aligned)

Loop3:
    lsl   x11, x9, x5
    orr   x0, x10, x11            // factor in the way number and cache number
    lsl   x11, x7, x2
    orr   x0, x0, x11             // factor in the index number
    blr   x1                      // Goto requested cache operation
    subs  x9, x9, #1              // decrement the way number
    b.ge  Loop3
    subs  x7, x7, #1              // decrement the index
    b.ge  Loop2
	
L_Skip:
    add   x10, x10, #2            // increment the cache number
    cmp   x3, x10
    b.gt  Loop1

L_Finished:
    dsb   sy
    isb
    ldr x30,[sp],#16
    ret

ArmDisableDataCache:
    str x30,[sp,#-16]!
    mrs    x1, CurrentEL
    cmp    x1, #0xC
    b.eq   3f
    cmp    x1, #0x8
    b.eq   2f
1:  mrs     x0, sctlr_el1        // Get control register EL1
    b       4f
2:  mrs     x0, sctlr_el2        // Get control register EL2
    b       4f
3:  mrs     x0, sctlr_el3        // Get control register EL3
4:  and     x0, x0, #~CTRL_C_BIT  // Clear C bit
    mrs    x1, CurrentEL
    cmp    x1, #0xC
    b.eq   3f
    cmp    x1, #0x8
    b.eq   2f
1:  msr     sctlr_el1, x0        // Write back control register
    b       4f
2:  msr     sctlr_el2, x0        // Write back control register
    b       4f
3:  msr     sctlr_el3, x0        // Write back control register
4:  dsb     sy
    isb
    ldr x30,[sp],#16
    ret

ArmDisableInstructionCache:
    str x30,[sp,#-16]!
    mrs    x1, CurrentEL
    cmp    x1, #0xC
    b.eq   3f
    cmp    x1, #0x8
    b.eq   2f
1:  mrs     x0, sctlr_el1        // Get control register EL1
    b       4f
2:  mrs     x0, sctlr_el2        // Get control register EL2
    b       4f
3:  mrs     x0, sctlr_el3        // Get control register EL3
4:  and     x0, x0, #~CTRL_I_BIT  // Clear I bit
    mrs    x1, CurrentEL
    cmp    x1, #0xC
    b.eq   3f
    cmp    x1, #0x8
    b.eq   2f
1:  msr     sctlr_el1, x0        // Write back control register
    b       4f
2:  msr     sctlr_el2, x0        // Write back control register
    b       4f
3:  msr     sctlr_el3, x0        // Write back control register
4:  dsb     sy
    isb
    ldr x30,[sp],#16
    ret

ArmDisableMmu:
    str x30,[sp,#-16]!
    mrs    x1, CurrentEL
    cmp    x1, #0xC
    b.eq   3f
    cmp    x1, #0x8
    b.eq   2f
1:  mrs     x0, sctlr_el1        // Read System Control Register EL1
    b       4f
2:  mrs     x0, sctlr_el2        // Read System Control Register EL2
    b       4f
3:  mrs     x0, sctlr_el3        // Read System Control Register EL3
4:  and     x0, x0, #~CTRL_M_BIT  // Clear MMU enable bit
    mrs    x1, CurrentEL
    cmp    x1, #0xC
    b.eq   3f
    cmp    x1, #0x8
    b.eq   2f
1:  msr     sctlr_el1, x0        // Write back
    tlbi    vmalle1
    b       4f
2:  msr     sctlr_el2, x0        // Write back
    tlbi    alle2
    b       4f
3:  msr     sctlr_el3, x0        // Write back
    tlbi    alle3
4:  dsb     sy
    isb
    ldr x30,[sp],#16
    ret
	
InformMailbox:
    ldr x6,=MAILBOX_BASE_ADDR            //Store 0xffa30000  mailbox base adress to X6
    mov w1,#MAILBOX_COE_INT_FLAG         //Enable COE save in w1
    orr w1,w1,#MAILBOX_RIE_INT_FLAG      //Enable RIE save in w1
    str w1,[x6,#OFFSET_INT_FLAG]         //Store w1 setting to enable interupt Cout into 0x0c <-- Interupt flags offset
    ldr w4,[x6,#OFFSET_STATUS]           //Check Mailbox Status before sending urgent command
    ldr w1,=MAILBOX_SEND_CMD             //Setup cmd to be send
    str w1,[x6,#OFFSET_URG]              //Write command to urgent location
    mov w1,#1			         //Put 1 into w4 to ring the door bell
    str w1,[x6,#OFFSET_DOOR_BELL_TO_SDM] //Ring the door bell of SDM
	
    ldr w5,[x6,#OFFSET_STATUS]           //Check New Mailbox Status
    and w4, w4, #DAIF_UA_BIT
    and w5, w5, #DAIF_UA_BIT
    cmp w5, w4                           //Check if UA is enabled.
    b.eq NO_UACK
    mov w1,#0
    ret
NO_UACK:
    mov w1,#~0
    ret

