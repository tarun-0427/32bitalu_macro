#!/bin/bash

# create report folder
mkdir -p reports/lvs

# run LVS
netgen -batch lvs \
"signoff/extraction/alu_32bit.spice alu_32bit" \
"signoff/extraction/net_flat.spice alu_32bit" \
$PDK_ROOT/sky130A/libs.tech/netgen/sky130A_setup.tcl \
signoff/lvs/lvs_report.log
