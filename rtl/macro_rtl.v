`timescale 1ns/1ps

module alu_32bit (
    input  wire         clk,
    input  wire         rst_n,       // Active-low synchronous reset

    input  wire         valid_i,
    input  wire [3:0]   opcode,
    input  wire [31:0]  operand_a,
    input  wire [31:0]  operand_b,

    output reg  [31:0]  result_o,
    output reg          valid_o,
    output reg          carry_o,
    output reg          overflow_o,
    output reg          zero_o
);

    // ============================================================
    // Input Register Stage
    // ============================================================

    reg [31:0] a_q;
    reg [31:0] b_q;
    reg [3:0]  opcode_q;
    reg        valid_q;

     always @(posedge clk or negedge rst_n)  
     begin
        if (!rst_n) begin
            a_q      <= 32'd0;
            b_q      <= 32'd0;
            opcode_q <= 4'd0;
            valid_q  <= 1'b0;
        end else begin
            a_q      <= operand_a;
            b_q      <= operand_b;
            opcode_q <= opcode;
            valid_q  <= valid_i;
        end
    end


    // ============================================================
    // Combinational ALU Blocks (Parallel Compute)
    // ============================================================

    // ---------- Arithmetic Block ----------
    wire [32:0] add_ext;
    wire [32:0] sub_ext;

    assign add_ext = {1'b0, a_q} + {1'b0, b_q};
    assign sub_ext = {1'b0, a_q} + {1'b0, ~b_q} + 33'd1;

    wire [31:0] add_result = add_ext[31:0];
    wire [31:0] sub_result = sub_ext[31:0];

    wire add_carry = add_ext[32];
    wire sub_carry = sub_ext[32];

    // Signed overflow detection
    wire add_overflow = (~(a_q[31] ^ b_q[31])) & (add_result[31] ^ a_q[31]);
    wire sub_overflow = (a_q[31] ^ b_q[31]) & (sub_result[31] ^ a_q[31]);

    // ---------- Logic Block ----------
    wire [31:0] and_result = a_q & b_q;
    wire [31:0] or_result  = a_q | b_q;
    wire [31:0] xor_result = a_q ^ b_q;

    // ---------- Shift Block ----------
    wire [4:0]  shamt = b_q[4:0];

    wire [31:0] sll_result = a_q << shamt;
    wire [31:0] srl_result = a_q >> shamt;
    wire [31:0] sra_result = $signed(a_q) >>> shamt;

    // ---------- SLT (Signed) ----------
    // Correct signed comparison: sign(sub_result) XOR overflow
    wire slt_bit = sub_result[31] ^ sub_overflow;
    wire [31:0] slt_result = {31'd0, slt_bit};

    // ============================================================
    // Final Result Mux
    // ============================================================

    reg  [31:0] result_comb;
    reg         carry_comb;
    reg         overflow_comb;

    always @(*) begin
        // Default safe values
        result_comb   = 32'd0;
        carry_comb    = 1'b0;
        overflow_comb = 1'b0;

        case (opcode_q)

            4'b0000: begin // ADD
                result_comb   = add_result;
                carry_comb    = add_carry;
                overflow_comb = add_overflow;
            end

            4'b0001: begin // SUB
                result_comb   = sub_result;
                carry_comb    = sub_carry;
                overflow_comb = sub_overflow;
            end

            4'b0010: begin // SLT
                result_comb   = slt_result;
                carry_comb    = 1'b0;
                overflow_comb = 1'b0;
            end

            4'b0011: result_comb = and_result; // AND
            4'b0100: result_comb = or_result;  // OR
            4'b0101: result_comb = xor_result; // XOR

            4'b0110: result_comb = sll_result; // SLL
            4'b0111: result_comb = srl_result; // SRL
            4'b1000: result_comb = sra_result; // SRA

            default: begin
                result_comb   = 32'd0;
                carry_comb    = 1'b0;
                overflow_comb = 1'b0;
            end
        endcase
    end


    // ============================================================
    // Output Register Stage
    // ============================================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_o    <= 32'd0;
            valid_o     <= 1'b0;
            carry_o     <= 1'b0;
            overflow_o  <= 1'b0;
            zero_o      <= 1'b0;
        end else begin
            result_o    <= result_comb;
            valid_o     <= valid_q;
            carry_o     <= carry_comb;
            overflow_o  <= overflow_comb;
            zero_o      <= (result_comb == 32'd0);
        end
    end

endmodule
