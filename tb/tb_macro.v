`timescale 1ns/1ps

module tb_alu_32bit;

reg clk;
reg rst_n;

reg valid_i;
reg [3:0] opcode;
reg [31:0] operand_a;
reg [31:0] operand_b;

wire [31:0] result_o;
wire valid_o;
wire carry_o;
wire overflow_o;
wire zero_o;


alu_32bit dut (
    .clk(clk),
    .rst_n(rst_n),
    .valid_i(valid_i),
    .opcode(opcode),
    .operand_a(operand_a),
    .operand_b(operand_b),
    .result_o(result_o),
    .valid_o(valid_o),
    .carry_o(carry_o),
    .overflow_o(overflow_o),
    .zero_o(zero_o)
);


//////////////////////////////////////
// CLOCK
//////////////////////////////////////

initial clk = 0;
always #5 clk = ~clk;


//////////////////////////////////////
// EXPECTED RESULT
//////////////////////////////////////

reg [31:0] expected_result;
reg expected_zero;

task compute_expected;

input [3:0] op;
input [31:0] a;
input [31:0] b;

reg [32:0] add_ext;
reg [32:0] sub_ext;
reg slt_bit;

begin

add_ext = {1'b0,a} + {1'b0,b};
sub_ext = {1'b0,a} + {1'b0,~b} + 33'd1;

case(op)

4'b0000: expected_result = add_ext[31:0];
4'b0001: expected_result = sub_ext[31:0];

4'b0010:
begin
slt_bit = sub_ext[31] ^ ((a[31]^b[31]) & (sub_ext[31]^a[31]));
expected_result = {31'd0,slt_bit};
end

4'b0011: expected_result = a & b;
4'b0100: expected_result = a | b;
4'b0101: expected_result = a ^ b;

4'b0110: expected_result = a << b[4:0];
4'b0111: expected_result = a >> b[4:0];
4'b1000: expected_result = $signed(a) >>> b[4:0];

default: expected_result = 0;

endcase

expected_zero = (expected_result == 0);

end
endtask


//////////////////////////////////////
// SCOREBOARD
//////////////////////////////////////

reg [31:0] exp_result_queue [0:2000];
reg exp_zero_queue [0:2000];

integer wr_ptr;
integer rd_ptr;

integer test_count;
integer error_count;


//////////////////////////////////////
// CHECKER
//////////////////////////////////////

always @(posedge clk)
begin

if(!rst_n)
begin
rd_ptr <= 0;
end

else if(valid_o == 1'b1)
begin

test_count <= test_count + 1;

if(result_o !== exp_result_queue[rd_ptr])
begin
$display("ERROR result mismatch exp=%h got=%h",
exp_result_queue[rd_ptr], result_o);
error_count <= error_count + 1;
end

if(zero_o !== exp_zero_queue[rd_ptr])
begin
$display("ERROR zero flag mismatch");
error_count <= error_count + 1;
end

rd_ptr <= rd_ptr + 1;

end

end


//////////////////////////////////////
// STIMULUS
//////////////////////////////////////

integer i;

initial
begin

`ifdef GLS
$dumpfile("gls_wave.vcd");
`else
$dumpfile("rtl_wave.vcd");
`endif

$dumpvars(0,tb_alu_32bit);


//////////////////////////////////////
// INITIAL VALUES
//////////////////////////////////////

rst_n = 0;
valid_i = 0;
repeat(20) @(posedge clk); // Hold reset long

@(negedge clk); // align release
rst_n = 1; 
repeat(10) @(posedge clk); // pipeline to flush


operand_a = 0;
operand_b = 0;
opcode = 0;

wr_ptr = 0;
rd_ptr = 0;

test_count = 0;
error_count = 0;

//////////////////////////////////////
// RANDOM TESTS
//////////////////////////////////////

for(i=0;i<1000;i=i+1)
begin

@(negedge clk);

operand_a = $random;
operand_b = $random;
opcode = $urandom_range(0,8);

compute_expected(opcode,operand_a,operand_b);

exp_result_queue[wr_ptr] = expected_result;
exp_zero_queue[wr_ptr] = expected_zero;

wr_ptr = wr_ptr + 1;

valid_i = 1;

@(posedge clk);

@(negedge clk);

valid_i = 0;

end


//////////////////////////////////////
// FINISH
//////////////////////////////////////

repeat(20) @(posedge clk);

if(error_count==0)
begin
$display("=================================");
$display("TEST PASSED");
$display("Total tests = %0d",test_count);
$display("=================================");
end
else
begin
$display("=================================");
$display("TEST FAILED");
$display("Errors = %0d",error_count);
$display("=================================");
end

$finish;

end

endmodule
