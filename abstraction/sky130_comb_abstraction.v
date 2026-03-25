/* SKY130 combinational abstraction for formal equivalence */
/* Exact cell names only */

///////////////////////
/* AND family */
///////////////////////

(* techmap_celltype = "sky130_fd_sc_hd__and2_0" *)
module sky130_fd_sc_hd__and2_0 (A, B, X);
input A, B;
output X;
assign X = A & B;
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__and3_1" *)
module sky130_fd_sc_hd__and3_1 (A, B, C, X);
input A,B,C;
output X;
assign X = A & B & C;
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__and4_1" *)
module sky130_fd_sc_hd__and4_1 (A,B,C,D,X);
input A,B,C,D;
output X;
assign X = A & B & C & D;
endmodule


///////////////////////
/* OR family */
///////////////////////

(* techmap_celltype = "sky130_fd_sc_hd__or3_1" *)
module sky130_fd_sc_hd__or3_1 (A,B,C,X);
input A,B,C;
output X;
assign X = A | B | C;
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__or4_1" *)
module sky130_fd_sc_hd__or4_1 (A,B,C,D,X);
input A,B,C,D;
output X;
assign X = A | B | C | D;
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__or4b_1" *)
module sky130_fd_sc_hd__or4b_1 (A,B,C,D_N,X);
input A,B,C,D_N;
output X;
assign X = A | B | C | ~D_N;
endmodule


///////////////////////
/* XOR */
///////////////////////

(* techmap_celltype = "sky130_fd_sc_hd__xor2_1" *)
module sky130_fd_sc_hd__xor2_1 (A,B,X);
input A,B;
output X;
assign X = A ^ B;
endmodule


///////////////////////
/* NOR */
///////////////////////

(* techmap_celltype = "sky130_fd_sc_hd__nor2b_1" *)
module sky130_fd_sc_hd__nor2b_1 (A,B_N,Y);
input A,B_N;
output Y;
assign Y = ~(A | ~B_N);
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__nor3b_1" *)
module sky130_fd_sc_hd__nor3b_1 (A,B,C_N,Y);
input A,B,C_N;
output Y;
assign Y = ~(A | B | ~C_N);
endmodule


///////////////////////
/* MUX */
///////////////////////

(* techmap_celltype = "sky130_fd_sc_hd__mux2_1" *)
module sky130_fd_sc_hd__mux2_1 (A0,A1,S,X);
input A0,A1,S;
output X;
assign X = S ? A1 : A0;
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__mux2i_1" *)
module sky130_fd_sc_hd__mux2i_1 (A0,A1,S,Y);
input A0,A1,S;
output Y;
assign Y = ~(S ? A1 : A0);
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__mux4_2" *)
module sky130_fd_sc_hd__mux4_2 (A0,A1,A2,A3,S0,S1,X);
input A0,A1,A2,A3,S0,S1;
output X;
assign X = S1 ? (S0 ? A3 : A2) : (S0 ? A1 : A0);
endmodule


///////////////////////
/* MAJORITY */
///////////////////////

(* techmap_celltype = "sky130_fd_sc_hd__maj3_1" *)
module sky130_fd_sc_hd__maj3_1 (A,B,C,X);
input A,B,C;
output X;
assign X = (A&B) | (B&C) | (A&C);
endmodule


///////////////////////
/* AO / OA logic */
///////////////////////

(* techmap_celltype = "sky130_fd_sc_hd__a21o_1" *)
module sky130_fd_sc_hd__a21o_1 (A1,A2,B1,X);
input A1,A2,B1;
output X;
assign X = (A1 & A2) | B1;
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__a21bo_1" *)
module sky130_fd_sc_hd__a21bo_1 (A1,A2,B1_N,X);
input A1,A2,B1_N;
output X;
assign X = (A1 & A2) | ~B1_N;
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__a211o_1" *)
module sky130_fd_sc_hd__a211o_1 (A1,A2,B1,C1,X);
input A1,A2,B1,C1;
output X;
assign X = (A1 & A2) | B1 | C1;
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__a2111o_1" *)
module sky130_fd_sc_hd__a2111o_1 (A1,A2,B1,C1,D1,X);
input A1,A2,B1,C1,D1;
output X;
assign X = (A1 & A2) | B1 | C1 | D1;
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__a221o_1" *)
module sky130_fd_sc_hd__a221o_1 (A1,A2,B1,B2,C1,X);
input A1,A2,B1,B2,C1;
output X;
assign X = (A1 & A2) | (B1 & B2) | C1;
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__a22o_1" *)
module sky130_fd_sc_hd__a22o_1 (A1,A2,B1,B2,X);
input A1,A2,B1,B2;
output X;
assign X = (A1 & A2) | (B1 & B2);
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__a31o_1" *)
module sky130_fd_sc_hd__a31o_1 (A1,A2,A3,B1,X);
input A1,A2,A3,B1;
output X;
assign X = (A1 & A2 & A3) | B1;
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__a311o_1" *)
module sky130_fd_sc_hd__a311o_1 (A1,A2,A3,B1,C1,X);
input A1,A2,A3,B1,C1;
output X;
assign X = (A1 & A2 & A3) | B1 | C1;
endmodule


///////////////////////
/* O21 / O211 */
///////////////////////

(* techmap_celltype = "sky130_fd_sc_hd__o21a_1" *)
module sky130_fd_sc_hd__o21a_1 (A1,A2,B1,X);
input A1,A2,B1;
output X;
assign X = (A1 | A2) & B1;
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__o211a_1" *)
module sky130_fd_sc_hd__o211a_1 (A1,A2,B1,C1,X);
input A1,A2,B1,C1;
output X;
assign X = (A1 | A2) & (B1 | C1);
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__o22a_1" *)
module sky130_fd_sc_hd__o22a_1 (A1,A2,B1,B2,X);
input A1,A2,B1,B2;
output X;
assign X = (A1 | A2) & (B1 | B2);
endmodule

(* techmap_celltype = "sky130_fd_sc_hd__o31a_1" *)
module sky130_fd_sc_hd__o31a_1 (A1,A2,A3,B1,X);
input A1,A2,A3,B1;
output X;
assign X = (A1 | A2 | A3) & B1;
endmodule
