#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2021 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of PCIe for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************

source ./arguments_solver.tcl
source ./utils.tcl
set sub_qsys_hbm subsys_hbm

create_system $sub_qsys_hbm

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

add_component_param "altera_clock_bridge clock_bridge_0
                    IP_FILE_PATH ip/$sub_qsys_hbm/clock_bridge_0.ip 
                    "
					
					
add_component_param "altera_iopll core_pll
                    IP_FILE_PATH ip/$sub_qsys_hbm/core_pll.ip 
                    gui_number_of_clocks 2
					gui_clock_name_string0 traffic_generator_clk
					gui_clock_name_string1 csr_clk
					gui_output_clock_frequency0 350.0
					gui_output_clock_frequency1 70.0					
					"
					
add_component_param "altera_reset_controller csr_reset_controller
                    IP_FILE_PATH ip/$sub_qsys_hbm/csr_reset_controller.ip 
                    NUM_RESET_INPUTS 1
					OUTPUT_RESET_SYNC_EDGES both									
					"
					
add_component_param "intel_mem_ip_reset_fanout_helper csr_reset_fanout_helper
				   IP_FILE_PATH ip/$sub_qsys_hbm/csr_reset_fanout_helper.ip
				   "
 
add_component_param "mem_reset_handler global_user_reset_extender
                    IP_FILE_PATH ip/$sub_qsys_hbm/global_user_reset_extender.ip
					NUM_CONDUITS 1
					CONDUIT_TYPE_0 local_cal_success
					"

add_component_param "mem_reset_handler global_user_reset_handler
                    IP_FILE_PATH ip/$sub_qsys_hbm/global_user_reset_handler.ip
					NUM_CONDUITS 1
					CONDUIT_TYPE_0 export
					"

add_component_param "hbm_fp hbm_fp_0
                    IP_FILE_PATH ip/$sub_qsys_hbm/hbm_fp_0.ip 
                    CTRL_CH1_EN 0
					CTRL_CH3_EN 0
					CTRL_CH4_EN 0
					CTRL_CH5_EN 0
					CTRL_CH6_EN 0
					CTRL_CH7_EN 0
					CTRL_CH0_HBM_DATA_MODE B256_ECC	
					CTRL_CH0_PSEUDO_BL8_EN 0
					"

add_component_param "altera_reset_bridge hbm_only_reset_bridge 
                    IP_FILE_PATH ip/$sub_qsys_hbm/hbm_only_reset_bridge.ip 
                    SYNCHRONOUS_EDGES none					
					"

add_component_param "altera_reset_controller hbm_reset_controller 
                    IP_FILE_PATH ip/$sub_qsys_hbm/hbm_reset_controller.ip
                    NUM_RESET_INPUTS 1
                    OUTPUT_RESET_SYNC_EDGES both             
                    "

add_component_param "mem_reset_handler hbm_reset_merge
                    IP_FILE_PATH ip/$sub_qsys_hbm/hbm_reset_merge.ip
					NUM_RESETS 2                   
                    "

add_component_param "hps_adapter hps_adapter_0
                    IP_FILE_PATH ip/$sub_qsys_hbm/hps_adapter_0.ip
                    "	

add_component_param "intel_noc_initiator noc_initiator_with_wstrb
                    IP_FILE_PATH ip/$sub_qsys_hbm/noc_initiator_with_wstrb.ip  					
					NUM_AXI4_IF 4					
					"

add_component_param "hydra traffic_generator
                    IP_FILE_PATH ip/$sub_qsys_hbm/traffic_generator.ip
					NUM_DRIVERS 8
					DRIVER_0_MEM_AXI4_NUM_DQ_ALUS 1
					DRIVER_0_MEM_AXI4_NUM_DM_ALUS 1
					DRIVER_0_MEM_AXI4_AWID_WIDTH 7
					DRIVER_0_MEM_AXI4_USE_AWCACHE 0
					DRIVER_0_MEM_AXI4_USE_AWREGION 0
					DRIVER_0_MEM_AXI4_AWUSER_WIDTH 11
					DRIVER_0_MEM_AXI4_ARID_WIDTH 7
					DRIVER_0_MEM_AXI4_USE_ARCACHE 0
					DRIVER_0_MEM_AXI4_USE_ARREGION 0
					DRIVER_0_MEM_AXI4_ARUSER_WIDTH 11
					DRIVER_0_MEM_AXI4_WDATA_WIDTH 256
					DRIVER_0_MEM_AXI4_RDATA_WIDTH 256
					
					DRIVER_1_MEM_AXI4_NUM_DQ_ALUS 1
					DRIVER_1_MEM_AXI4_NUM_DM_ALUS 1
					DRIVER_1_MEM_AXI4_AWID_WIDTH 7
					DRIVER_1_MEM_AXI4_USE_AWCACHE 0
					DRIVER_1_MEM_AXI4_USE_AWREGION 0
					DRIVER_1_MEM_AXI4_AWUSER_WIDTH 11
					DRIVER_1_MEM_AXI4_ARID_WIDTH 7
					DRIVER_1_MEM_AXI4_USE_ARCACHE 0
					DRIVER_1_MEM_AXI4_USE_ARREGION 0
					DRIVER_1_MEM_AXI4_ARUSER_WIDTH 11
					DRIVER_1_MEM_AXI4_WDATA_WIDTH 256
					DRIVER_1_MEM_AXI4_RDATA_WIDTH 256
					
					DRIVER_2_MEM_AXI4_NUM_DQ_ALUS 1
					DRIVER_2_MEM_AXI4_NUM_DM_ALUS 1
					DRIVER_2_MEM_AXI4_AWID_WIDTH 7
					DRIVER_2_MEM_AXI4_USE_AWCACHE 0
					DRIVER_2_MEM_AXI4_USE_AWREGION 0
					DRIVER_2_MEM_AXI4_AWUSER_WIDTH 11
					DRIVER_2_MEM_AXI4_ARID_WIDTH 7
					DRIVER_2_MEM_AXI4_USE_ARCACHE 0
					DRIVER_2_MEM_AXI4_USE_ARREGION 0
					DRIVER_2_MEM_AXI4_ARUSER_WIDTH 11
					DRIVER_2_MEM_AXI4_WDATA_WIDTH 256
					DRIVER_2_MEM_AXI4_RDATA_WIDTH 256
					
					DRIVER_3_MEM_AXI4_NUM_DQ_ALUS 1
					DRIVER_3_MEM_AXI4_NUM_DM_ALUS 1
					DRIVER_3_MEM_AXI4_AWID_WIDTH 7
					DRIVER_3_MEM_AXI4_USE_AWCACHE 0
					DRIVER_3_MEM_AXI4_USE_AWREGION 0
					DRIVER_3_MEM_AXI4_AWUSER_WIDTH 11
					DRIVER_3_MEM_AXI4_ARID_WIDTH 7
					DRIVER_3_MEM_AXI4_USE_ARCACHE 0
					DRIVER_3_MEM_AXI4_USE_ARREGION 0
					DRIVER_3_MEM_AXI4_ARUSER_WIDTH 11
					DRIVER_3_MEM_AXI4_WDATA_WIDTH 256
					DRIVER_3_MEM_AXI4_RDATA_WIDTH 256
					
					DRIVER_4_MEM_AXI4_NUM_DQ_ALUS 1
					DRIVER_4_MEM_AXI4_NUM_DM_ALUS 1
					DRIVER_4_MEM_AXI4_AWID_WIDTH 7
					DRIVER_4_MEM_AXI4_USE_AWCACHE 0
					DRIVER_4_MEM_AXI4_USE_AWREGION 0
					DRIVER_4_MEM_AXI4_AWUSER_WIDTH 11
					DRIVER_4_MEM_AXI4_ARID_WIDTH 7
					DRIVER_4_MEM_AXI4_USE_ARCACHE 0
					DRIVER_4_MEM_AXI4_USE_ARREGION 0
					DRIVER_4_MEM_AXI4_ARUSER_WIDTH 11
					DRIVER_4_MEM_AXI4_WDATA_WIDTH 256
					DRIVER_4_MEM_AXI4_RDATA_WIDTH 256
					
					DRIVER_5_MEM_AXI4_NUM_DQ_ALUS 1
					DRIVER_5_MEM_AXI4_NUM_DM_ALUS 1
					DRIVER_5_MEM_AXI4_AWID_WIDTH 7
					DRIVER_5_MEM_AXI4_USE_AWCACHE 0
					DRIVER_5_MEM_AXI4_USE_AWREGION 0
					DRIVER_5_MEM_AXI4_AWUSER_WIDTH 11
					DRIVER_5_MEM_AXI4_ARID_WIDTH 7
					DRIVER_5_MEM_AXI4_USE_ARCACHE 0
					DRIVER_5_MEM_AXI4_USE_ARREGION 0
					DRIVER_5_MEM_AXI4_ARUSER_WIDTH 11
					DRIVER_5_MEM_AXI4_WDATA_WIDTH 256
					DRIVER_5_MEM_AXI4_RDATA_WIDTH 256
					
					DRIVER_6_MEM_AXI4_NUM_DQ_ALUS 1
					DRIVER_6_MEM_AXI4_NUM_DM_ALUS 1
					DRIVER_6_MEM_AXI4_AWID_WIDTH 7
					DRIVER_6_MEM_AXI4_USE_AWCACHE 0
					DRIVER_6_MEM_AXI4_USE_AWREGION 0
					DRIVER_6_MEM_AXI4_AWUSER_WIDTH 11
					DRIVER_6_MEM_AXI4_ARID_WIDTH 7
					DRIVER_6_MEM_AXI4_USE_ARCACHE 0
					DRIVER_6_MEM_AXI4_USE_ARREGION 0
					DRIVER_6_MEM_AXI4_ARUSER_WIDTH 11
					DRIVER_6_MEM_AXI4_WDATA_WIDTH 256
					DRIVER_6_MEM_AXI4_RDATA_WIDTH 256
					
					DRIVER_7_MEM_AXI4_NUM_DQ_ALUS 1
					DRIVER_7_MEM_AXI4_NUM_DM_ALUS 1
					DRIVER_7_MEM_AXI4_AWID_WIDTH 7
					DRIVER_7_MEM_AXI4_USE_AWCACHE 0
					DRIVER_7_MEM_AXI4_USE_AWREGION 0
					DRIVER_7_MEM_AXI4_AWUSER_WIDTH 11
					DRIVER_7_MEM_AXI4_ARID_WIDTH 7
					DRIVER_7_MEM_AXI4_USE_ARCACHE 0
					DRIVER_7_MEM_AXI4_USE_ARREGION 0
					DRIVER_7_MEM_AXI4_ARUSER_WIDTH 11
					DRIVER_7_MEM_AXI4_WDATA_WIDTH 256
					DRIVER_7_MEM_AXI4_RDATA_WIDTH 256
					
					CONFIG_INTF_MODE CONFIG_INTF_MODE_REMOTE_JTAG
					
					"
					
add_component_param "altera_reset_controller traffic_generator_reset_controller
                    IP_FILE_PATH ip/$sub_qsys_hbm/traffic_generator_reset_controller.ip                    					
					NUM_RESET_INPUTS 1
                    OUTPUT_RESET_SYNC_EDGES both  
					"					

add_component_param "intel_mem_ip_reset_fanout_helper traffic_generator_reset_fanout_helper
                    IP_FILE_PATH ip/$sub_qsys_hbm/traffic_generator_reset_fanout_helper.ip				
					"

    

# connections and connection parameters

connect "   clock_bridge_0.out_clk 									hbm_fp_0.fabric_clk
			clock_bridge_0.out_clk									hbm_reset_controller.clk
			clock_bridge_0.out_clk									hps_adapter_0.clock_sink
			clock_bridge_0.out_clk									noc_initiator_with_wstrb.s0_axi4_aclk
			clock_bridge_0.out_clk									traffic_generator_reset_controller.clk
			clock_bridge_0.out_clk									traffic_generator_reset_fanout_helper.clk
			core_pll.locked 										global_user_reset_handler.conduit_0
            core_pll.outclk0 										noc_initiator_with_wstrb.s1_axi4_aclk
			core_pll.outclk0 										noc_initiator_with_wstrb.s2_axi4_aclk
			core_pll.outclk0										noc_initiator_with_wstrb.s3_axi4_aclk
			core_pll.outclk0										traffic_generator.driver0_clk
			core_pll.outclk0										traffic_generator.driver1_clk
			core_pll.outclk0										traffic_generator.driver2_clk
			core_pll.outclk0										traffic_generator.driver3_clk
			core_pll.outclk0										traffic_generator.driver4_clk
			core_pll.outclk0										traffic_generator.driver5_clk
			core_pll.outclk0										traffic_generator.driver6_clk
			core_pll.outclk0										traffic_generator.driver7_clk
			core_pll.outclk1										csr_reset_controller.clk
			core_pll.outclk1										csr_reset_fanout_helper.clk
			core_pll.outclk1										traffic_generator.remote_intf_clk
			csr_reset_controller.reset_out							csr_reset_fanout_helper.sresetn_in
			csr_reset_fanout_helper.sresetn_out_0					traffic_generator.remote_intf_reset
			global_user_reset_extender.reset_n_out					csr_reset_controller.reset_in0
			global_user_reset_extender.reset_n_out					traffic_generator_reset_controller.reset_in0
			global_user_reset_handler.reset_n_out					global_user_reset_extender.reset_n_0
			global_user_reset_handler.reset_n_out					hbm_reset_merge.reset_n_0
			hbm_fp_0.local_cal_success								global_user_reset_extender.conduit_0
			hbm_only_reset_bridge.out_reset							hbm_reset_merge.reset_n_1
			hbm_reset_controller.reset_out							hbm_fp_0.hbm_reset_n
			hbm_reset_merge.reset_n_out								hbm_reset_controller.reset_in0
			traffic_generator_reset_controller.reset_out			traffic_generator_reset_fanout_helper.sresetn_in
			traffic_generator_reset_fanout_helper.sresetn_out_0		traffic_generator.driver0_reset
			traffic_generator_reset_fanout_helper.sresetn_out_1		traffic_generator.driver1_reset
			traffic_generator_reset_fanout_helper.sresetn_out_2		traffic_generator.driver2_reset
			traffic_generator_reset_fanout_helper.sresetn_out_21	noc_initiator_with_wstrb.s1_axi4_aresetn
			traffic_generator_reset_fanout_helper.sresetn_out_22	noc_initiator_with_wstrb.s2_axi4_aresetn
			traffic_generator_reset_fanout_helper.sresetn_out_23	noc_initiator_with_wstrb.s3_axi4_aresetn
			traffic_generator_reset_fanout_helper.sresetn_out_3		traffic_generator.driver3_reset
			traffic_generator_reset_fanout_helper.sresetn_out_4		traffic_generator.driver4_reset
			traffic_generator_reset_fanout_helper.sresetn_out_5		traffic_generator.driver5_reset
			traffic_generator_reset_fanout_helper.sresetn_out_6		traffic_generator.driver6_reset
			traffic_generator_reset_fanout_helper.sresetn_out_7		traffic_generator.driver7_reset
						
"           


connect_map "   hps_adapter_0.altera_axi4_master		noc_initiator_with_wstrb.s0_axi4 	0x0000
				noc_initiator_with_wstrb.i0_axi4noc		hbm_fp_0.t_ch0_ch1_sb_axi4noc		0x0000000400000000
				noc_initiator_with_wstrb.i0_axi4noc		hbm_fp_0.t_ch0_u0_axi4noc			0x0000
				noc_initiator_with_wstrb.i0_axi4noc		hbm_fp_0.t_ch2_ch3_sb_axi4noc		0x0000000408000000
				noc_initiator_with_wstrb.i1_axi4noc		hbm_fp_0.t_ch0_u1_axi4noc			0x0000
				noc_initiator_with_wstrb.i2_axi4noc		hbm_fp_0.t_ch2_u0_axi4noc			0x0000
				noc_initiator_with_wstrb.i3_axi4noc		hbm_fp_0.t_ch2_u1_axi4noc			0x0000
				traffic_generator.driver1_axi4			noc_initiator_with_wstrb.s1_axi4	0x0000
				traffic_generator.driver2_axi4			noc_initiator_with_wstrb.s2_axi4	0x0000
				traffic_generator.driver3_axi4			noc_initiator_with_wstrb.s3_axi4	0x0000
												
"



# exported interfaces

export 	clock_bridge_0				in_clk 				clock_bridge_0_in_clk
export	core_pll					refclk				core_pll_refclk
export	core_pll					reset				core_pll_reset
export	global_user_reset_handler	reset_n_0			global_user_reset
export	hbm_fp_0					cattrip_i			hbm_cattrip_virtual_i		
export	hbm_fp_0					temp_i				hbm_temp_virtual_i							
export	hbm_fp_0					uibpll_refclk		uibpll_refclk			
export	hbm_only_reset_bridge		in_reset			hbm_only_reset			
export	hps_adapter_0				altera_axi4_slave	hps_adapter_0_altera_axi4_slave				
export	hps_adapter_0				reset_sink			hps_adapter_0_reset_sink					
export	noc_initiator_with_wstrb	s0_axi4_aresetn		noc_initiator_with_wstrb_s0_axi4_aresetn	


# # interconnect requirements
# set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
# set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {1}
# set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
# set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    
sync_sysinfo_parameters 
    
save_system ${sub_qsys_hbm}.qsys
