read_liberty ~/open_pdks/sky130/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

read_db routing/routed.odb

read_sdc constraints/constraints.sdc

set_propagated_clock [all_clocks]

set_wire_rc -layer met3

estimate_parasitics -placement

report_checks -path_delay max
report_checks -path_delay max -digits 4 > signoff/post_sta/post_sta_setup.rpt


report_checks -path_delay min -digits 4
report_checks -path_delay min -digits 4 > signoff/post_sta/post_sta_hold.rpt


report_tns
report_tns > signoff/post_sta/post_sta_tns.rpt

report_wns
report_worst_slack
report_worst_slack > signoff/post_sta/post_sta_worst_slack.rpt

exit
