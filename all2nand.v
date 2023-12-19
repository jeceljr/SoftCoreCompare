(* techmap_celltype = "NOT" *)
module NAND_NOT (input A, output Y);
	NAND u1 (.A(A), .B(A), .Y(Y));
endmodule

(* techmap_celltype = "BUF" *)
module NAND_BUF (input A, output Y);
	wire out1;
	NOT u1 (.A(A), .Y(out1));
	NOT u2 (.A(A), .Y(Y));
endmodule

(* techmap_celltype = "DFF_PP0" *)
module DFF_PP0(input C, input D, input R, output Q);
    wire not_R;
    wire C_nand_R;
    wire D_nand_Feedback;
    wire C_nand_not_R;
    wire nand_1;
    wire nand_2;
    wire nand_3;
    wire nand_dff_1;
    wire nand_dff_2;
    wire nand_QBAR;

    NOT u0 (.A(R), .Y(not_R));
    NAND u1 (.A(not_R), .B(C), .Y(C_nand_not_R));
    NAND u2 (.A(D), .B(nand_dff_1), .Y(D_nand_Feedback));
    NAND u3 (.A(D_nand_Feedback), .B(nand_dff_2), .Y(nand_1));
    NAND u4 (.A(nand_1), .B(not_R), .Y(nand_2));
    NAND u5 (.A(nand_2), .B(nand_2), .Y(nand_3));
    NAND u6 (.A(nand_2), .B(C_nand_not_R), .Y(nand_dff_1));
    NAND u7 (.A(nand_3), .B(C_nand_not_R), .Y(nand_dff_2));
    NAND u8 (.A(nand_dff_1), .B(Q), .Y(nand_QBAR));
    NAND u9 (.A(nand_dff_2), .B(nand_QBAR), .Y(Q));
endmodule
/*
(* techmap_celltype = "DFF_PP0" *)
module NAND_DFF(input C, input D, input R, output Q);
    wire nand1_out; // output from nand1
    wire nand2_out; // output from nand2
    wire not_D;
    wire QBAR;

    wire not_R;
    wire and_R;
    wire in;

    wire clock_edge, not_clock_edge, clock_edge_or_reset;
    wire reset_edge, not_reset_edge;
    wire not_1, not_2, not_3, not_4;
    wire not_5, not_6, not_7, not_8;
    
    // clock edge detection
    NOT n3 (.A(C), .Y(not_1));
    NOT n4 (.A(not_1), .Y(not_2));
    NOT n5 (.A(not_2), .Y(not_3));
    NAND u5 (.A(not_3), .B(C), .Y(not_clock_edge));
    NOT n7 (.A(not_clock_edge), .Y(clock_edge));

    // reset edge detection
    NOT n8 (.A(R), .Y(not_4));
    NOT n9 (.A(not_4), .Y(not_5));
    NOT n10 (.A(not_5), .Y(not_6));
    NOT n11 (.A(not_6), .Y(not_7));
    NOT n12 (.A(not_7), .Y(not_8));
    NAND u6 (.A(not_8), .B(R), .Y(not_reset_edge));
    NOT n13 (.A(not_reset_edge), .Y(reset_edge));

    // reset implementation in = D&~R;
    NAND u7 (.A(not_reset_edge), .B(D), .Y(and_R));
    NOT n14 (.A(and_R), .Y(in));

    // also edge detected will be 1 if reset is pressed c= c | R
    NAND u8 (.A(not_reset_edge), .B(not_clock_edge), .Y(clock_edge_or_reset));

    // dff
    NOT n1 (.A(in), .Y(not_D));
    NAND u1 (.A(clock_edge_or_reset), .B(in), .Y(nand1_out));
    NAND u2 (.A(clock_edge_or_reset), .B(not_D), .Y(nand2_out));
    NAND u3 (.A(nand1_out), .B(QBAR), .Y(Q));
    NAND u4 (.A(nand2_out), .B(Q), .Y(QBAR));

endmodule
*/
/*      clocked_on: "C";
        next_state: "D";
        clear: "R";
                               
(* techmap_celltype = "DFF_PP0" *)
module reduced_DFF(input C, input D, input R, output Q);
    
    wire nand1_out; // output from nand1
    wire nand2_out; // output from nand2
    wire not_D;
    wire QBAR;
    NOT n1 (.A(D), .Y(not_D));
    NAND u1 (.A(C), .B(D), .Y(nand1_out));
    NAND u2 (.A(C), .B(not_D), .Y(nand2_out));
    NAND u3 (.A(nand1_out), .B(QBAR), .Y(Q));
    NAND u4 (.A(nand2_out), .B(Q), .Y(QBAR));
endmodule
 */

