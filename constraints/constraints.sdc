# Clock Definition
create_clock -name clk -period 11.11 [get_ports clk]
# Clock uncertainty
set_clock_uncertainty 0.2 [get_clocks clk]
# Input Timing
set_input_delay 2.0 -clock clk [get_ports * -filter "direction==input&&name!=clk"]
# Output Timing
set_output_delay 2 -clock clk [all_outputs]
# Input Driver Model
set_driving_cell \
-lib_cell sky130_fd_sc_hd__inv_2 \
[get_ports {valid_i opcode operand_a operand_b}]
# Output Load Model
set_load 0.05 [all_outputs]
