/* SKY130 DFF abstraction for formal equivalence */
/* Exact match: sky130_fd_sc_hd__dfrtp_1 */

(* techmap_celltype = "sky130_fd_sc_hd__dfrtp_1" *)
module sky130_fd_sc_hd__dfrtp_1 (CLK, D, RESET_B, Q);

input CLK;
input D;
input RESET_B;
output Q;

/* convert active-low reset */
wire rst;
assign rst = ~RESET_B;

/* formal primitive */

$_DFF_PN0_ _TECHMAP_REPLACE_ (
    .C(CLK),
    .D(D),
    .R(rst),
    .Q(Q)
);

endmodule
