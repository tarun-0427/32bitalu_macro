set PDK_ROOT $::env(PDK_ROOT)
set SKY130A $PDK_ROOT/sky130A

file mkdir reports/floorplan
file mkdir reports/placement

#1. READ DESIGN

read_lef $SKY130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
read_lef $SKY130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
read_liberty $SKY130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog synthesis/mapped_net.v
link_design alu_32bit
read_sdc constraints/constraints.sdc

#2. FLOORPLAN & ANCHORS (Physical Foundation)

initialize_floorplan -utilization 60 -aspect_ratio 1.0 -core_space 5 -site unithd
make_tracks
place_pins -hor_layers met3 -ver_layers met2


     #reports
  report_design_area
  report_cell_usage
  report_clock_properties
  report_power

log_begin  reports/floorplan/floorplan.rpt
 report_design_area
 report_cell_usage
 report_clock_properties
 report_power

log_end

#INSERT TAPCELLS FIRST (as per your screenshot ISSUE 2)

tapcell -tapcell_master sky130_fd_sc_hd__tapvpwrvgnd_1 -distance 14 -tap_prefix TAP_

#3. GLOBAL CONNECT (The "Split" Syntax & Explicitly split these because () regex grouping fails in OpenROAD )

make_net VPWR
make_net VGND
add_global_connection -net VPWR -inst_pattern .* -pin_pattern VPWR -power
add_global_connection -net VPWR -inst_pattern .* -pin_pattern VPB
add_global_connection -net VGND -inst_pattern .* -pin_pattern VGND -ground
add_global_connection -net VGND -inst_pattern .* -pin_pattern VNB

global_connect

#4. PDN (Infrastructure before Logic)

set_voltage_domain -name CORE -power VPWR -ground VGND
define_pdn_grid -name core_grid -voltage_domains CORE
add_pdn_stripe -grid core_grid -layer met1 -followpins -width 0.48
add_pdn_stripe -grid core_grid -layer met4 -width 1.6 -pitch 20
add_pdn_connect -grid core_grid -layers {met1 met4}
pdngen


#POWER PINS SANITY PROOF

check_power_grid -net VPWR
check_power_grid -net VGND

#5
#global_placement
global_placement

#report
report_design_area
 log_begin  reports/placement/gpl_stat.rpt
 report_design_area
log_end

#detailed_placement
detailed_placement
check_placement
#report
log_begin reports/placement/dpl_stat.rpt
 report_design_area
 check_placement
log_end

write_def placement/placement.def
write_db  placement/placement.odb

exit
