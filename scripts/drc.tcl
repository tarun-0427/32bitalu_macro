# Load tech
tech load /home/a4/open_pdks/sky130/sky130A/libs.tech/magic/sky130A.tech

# Read GDS
gds read /home/a4/32bitalu_macro/signoff/final/flat/macro_32bit_flat.gds

# Load top cell
load alu_32bit_flat

# Expand full hierarchy
select top cell
expand

# Enable full DRC
drc euclidean on
drc style drc(full)

# Run DRC
drc check

# Print summary
set outfile [open "signoff/drc/drc.rpt" w]
set count [drc count total]
puts $outfile "Total DRC violations: $count"

# Dump detailed errors
set errors [drc listall why]
foreach err $errors {
    puts $outfile $err
}

close $outfile

# Also print to console
puts "DRC TOTAL VIOLATIONS: $count"

quit
