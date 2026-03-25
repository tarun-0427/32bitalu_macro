# CONFIG
SHELL := /bin/bash

TOP = alu_32bit

RTL = rtl/macro_rtl.v
TB  = tb/tb_macro.v

PDK_ROOT  ?= $(HOME)/open_pdks
OPENROAD  = openroad
MAGIC 	  =  magic -T /home/a4/open_pdks/sky130/sky130A/libs.tech/magic/sky130A.tech -rcfile /home/a4/open_pdks/sky130/sky130A/libs.tech/magic/sky130A.magicrc
MAGIC_TERMINAL  = magic -dnull -noconsole

LINT_SCRIPT      = scripts/lint.ys
SYNTH_GEN_SCRIPT = scripts/synth_gen.ys
SYNTH_MAP_SCRIPT = scripts/synth_map.ys
FEC_GEN_SCRIPT   = scripts/fec_gen.ys
STA_SCRIPT       = scripts/pre-sta.tcl

BACKEND_DIR =  scripts
SIGNOFF_DIR =  signoff

FLOORPLAN_SCRIPT = $(BACKEND_DIR)/floorplan__merged.tcl
CTS_SCRIPT       = $(BACKEND_DIR)/cts.tcl
ROUTE_SCRIPT     = $(BACKEND_DIR)/routing.tcl
POST_STA_SCRIPT  = $(BACKEND_DIR)/post_sta.tcl
DRC_SCRIPT 	 = $(BACKEND_DIR)/drc.tcl

REPORT_DIR = reports

.PHONY: all lint sim synth_gen synth_map fec_gen pre_sta floorplan cts route post_sta drc  clean

# FULL FLOW

all: drc

# FRONTEND

lint:
	@echo "[LINT]"
	mkdir -p $(REPORT_DIR)/lint
	yosys -s $(LINT_SCRIPT)

sim: lint
	@echo "[SIM]"
	mkdir -p sim
	iverilog -o sim/sim.out $(RTL) $(TB)
	vvp sim/sim.out > sim/sim.log

synth_gen: sim
	@echo "[SYNTH_GEN]"
	mkdir -p synthesis
	yosys -s $(SYNTH_GEN_SCRIPT)

synth_map: synth_gen
	@echo "[SYNTH_MAP]"
	yosys -s $(SYNTH_MAP_SCRIPT)

fec_gen: synth_map
	@echo "[FEC_GEN]"
	mkdir -p $(REPORT_DIR)/fec_gen
	yosys -s $(FEC_GEN_SCRIPT)

	@if grep -q "FAILED" $(REPORT_DIR)/fec_gen/equiv_status.rpt; then \
		echo "[FEC FAILED]"; exit 1; \
	else \
		echo "[FEC PASSED]"; \
	fi

pre_sta: synth_map
	@echo "[PRE-STA]"
	mkdir -p $(REPORT_DIR)/pre_sta
	sta $(STA_SCRIPT) > $(REPORT_DIR)/pre_sta/pre_sta.log

# BACKEND

floorplan: pre_sta
	@echo "[FLOORPLAN]"
	mkdir -p $(REPORT_DIR)/floorplan
	mkdir -p $(REPORT_DIR)/placement
	$(OPENROAD) $(FLOORPLAN_SCRIPT)

cts: floorplan
	@echo "[CTS]"
	$(OPENROAD) $(CTS_SCRIPT)

route: cts
	@echo "[ROUTING]"
	$(OPENROAD) $(ROUTE_SCRIPT)

post_sta: route
	@echo "[POST-STA]"
	$(OPENROAD) $(POST_STA_SCRIPT)
drc: post_sta
	@echo"[DRC]"
	mkdir -p $(SIGNOFF_DIR)/drc
	$(MAGIC_TERMINAL) $(DRC_SCRIPT)

# CLEAN

clean:
	@echo "[CLEAN]"
	rm -rf synthesis sim placement cts routing  
