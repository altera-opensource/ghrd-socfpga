

MAKE := make


MODULES += qsys_top
MODULES += subsys_hps
MODULES += subsys_jtg_mst
MODULES += subsys_periph


.PHONY: $(MODULES)
$(MODULES):
	$(MAKE) -C $@


.PHONY: all
all: $(MODULES)
	$(warning $?)
