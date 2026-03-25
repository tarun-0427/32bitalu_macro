 magic \
-T /home/a4/open_pdks/sky130/sky130A/libs.tech/magic/sky130A.tech \
-rcfile /home/a4/open_pdks/sky130/sky130A/libs.tech/magic/sky130A.magicrc


gds read /home/a4/open_pdks/sky130/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds

load alu_32bit.mag

select top cell

expand

#sanity check 

cellname list top

drc count
drc check 

gds write  alu_32bit_hier.gds
