set PDK_ROOT $::env(PDK_ROOT)
set SKY130A $PDK_ROOT/sky130A

file mkdir routing 
file mkdir reports
file mkdir reports/routing

read_lef $SKY130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
read_lef $SKY130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef

read_db cts/cts_final.odb

read_liberty $SKY130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

read_sdc constraints/constraints.sdc

detailed_placement

global_route

detailed_route


estimate_parasitics -global_routing

repair_timing

estimate_parasitics -global_routing

report_wns
report_tns

write_db routing/routed.odb

write_db routing/routed.def
# BASIC DESIGN STATS

report_design_area > reports/routing/area.rpt
report_cell_usage > reports/routing/cell_usage.rpt


# TIMING (POST-ROUTING)

report_checks -path_delay max -digits 4 > reports/routing/setup.rpt
report_checks -path_delay min -digits 4 > reports/routing/hold.rpt

report_tns > reports/routing/tns.rpt
report_wns > reports/routing/wns.rpt
report_worst_slack > reports/routing/worst_slack.rpt

# CLOCK

report_clock_properties > reports/routing/clock.rpt
report_clock_skew > reports/routing/clock_skew.rpt


# ROUTING QUALITY

report_route_status > reports/routing/route_status.rpt
report_congestion > reports/routing/congestion.rpt

# PARASITICS (ESTIMATED)
report_parasitics -summary > reports/routing/parasitics.rpt

# POWER (OPTIONAL BASIC)
report_power > reports/routing/power.rpt

