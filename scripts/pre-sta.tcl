read_liberty ~/open_pdks/sky130/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

read_verilog synthesis/mapped_net.v

link_design alu_32bit

read_sdc constraints/constraints.sdc


report_clock_properties
report_clock_properties      > reports/pre_sta/clock_properties.rpt

report_worst_slack
report_worst_slack           > reports/pre_sta/worst_slack.rpt

report_tns
report_tns                   > reports/pre_sta/tns.rpt

report_checks -path_delay max
report_checks -path_delay max > reports/pre_sta/setup_paths.rpt

report_checks -path_delay min
report_checks -path_delay min > reports/pre_sta/hold_paths.rpt

report_clock_skew
report_clock_skew            >  reports/pre_sta/clock_skew.rpt

report_clock_min_period
report_clock_min_period      >  reports/pre_sta/fmax_estimate.rpt

check_setup -verbose
check_setup -verbose         >  reports/pre_sta/constraint_check.rpt

exit

