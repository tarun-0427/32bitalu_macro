set PDK_ROOT $::env(PDK_ROOT)
set SKY130A $PDK_ROOT/sky130A

file mkdir cts/
file mkdir reports/
file mkdir reports/cts/

read_lef $SKY130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
read_lef $SKY130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
read_liberty ~/open_pdks/sky130/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

read_db placement/placement.odb
read_sdc constraints/constraints.sdc

set_wire_rc -layer met3

estimate_parasitics -placement

#set_propagated_clock [all_clocks]
clock_tree_synthesis

estimate_parasitics -placement

repair_timing

estimate_parasitics -placement


report_tns
report_wns
write_db cts/cts_final.odb
 report_clock_latency
 report_clock_skew


log_begin reports/cts/cts_stats.rpt

report_clock_skew
report_clock_latency
report_tns
report_wns

log_end

exit

