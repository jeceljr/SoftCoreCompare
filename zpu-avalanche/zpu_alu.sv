/*
 * MODULE: zpu_alu
 * DESCRIPTION: Contains ZPU alu
 * AUTHOR: Antonio J. Anton (aj <at> anro-ingenieros.com)
 *
 * REVISION HISTORY:
 * Revision 1.0, 14/09/2009
 * Initial public release
 *
 * COPYRIGHT:
 * Copyright (c) 2009 Antonio J. Anton
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
`timescale 1ns / 1ps
`include "zpu_defines.sv"

// --------- ZPU CORE ALU UNIT ---------------
module zpu_alu(
    input  wire [31:0]              alu_a,      // parameter A
    input  wire [31:0]              alu_b,      // parameter B
    output reg  [31:0]              alu_r,      // computed result
    input  wire                     flag_idim,  // for IMM alu op
    input  wire [`ALU_OP_WIDTH-1:0] alu_op,     // ALU operation
    input  wire                     clk,        // clock for syncronous multicycle operations
    output reg                      done        // done signal for alu operation
);

`ifdef ENABLE_MULT
// implement 32 bit pipeline multiplier
reg        mul_running;
reg [2:0]  mul_counter;
wire       mul_done = (mul_counter == 3);
reg [31:0] mul_result, mul_tmp1;
reg [31:0] a_in, b_in;

always@(posedge clk)
begin
  a_in          <= 0;
  b_in          <= 0;
  mul_tmp1      <= 0;
  mul_result    <= 0;
  mul_counter   <= 0;
  if(mul_running)
  begin    // infer pipeline multiplier
    a_in        <= alu_a;
    b_in        <= alu_b;
    mul_tmp1    <= a_in * b_in;
    mul_result  <= mul_tmp1;
    mul_counter <= mul_counter + 1;
  end
end
`endif

`ifdef ENABLE_DIV
// implement 32 bit divider
// Unsigned/Signed division based on Patterson and Hennessy's algorithm.
// Description: Calculates quotient.  The "sign" input determines whether
// signs (two's complement) should be taken into consideration.
// references: http://www.ece.lsu.edu/ee3755/2002/l07.html
reg  [63:0] qr;
wire [33:0] diff;
wire [31:0] quotient;
wire [31:0] dividend;
wire [31:0] divider;
reg  [6:0]  bit;
wire        div_done;
reg         div_running;
reg         divide_sign;
reg         negative_output;

assign div_done = !bit;
assign diff = qr[63:31] - {1'b0, divider};
assign quotient  = (!negative_output) ? qr[31:0] : ~qr[31:0] + 1'b1;
assign dividend  = (!divide_sign || !alu_a[31]) ? alu_a : ~alu_a + 1'b1;
assign divider   = (!divide_sign || !alu_b[31]) ? alu_b : ~alu_b + 1'b1;

always@(posedge clk)
begin
    bit <= 7'b1_000000;                // divider stopped
    if(div_running)
    begin
      if(bit[6])                    // divider started: initialize registers
      begin
          bit             <= 7'd32;
          qr              <= { 32'd0, dividend };
          negative_output <= divide_sign && ((alu_b[31] && !alu_a[31]) || (!alu_b[31] && alu_a[31]));
      end
      else                            // step by step divide
      begin
        if( diff[32] ) qr <= { qr[62:0], 1'd0 };
        else           qr <= { diff[31:0], qr[30:0], 1'd1 };
        bit <= bit - 1;
      end
   end
end
`endif

`ifdef ENABLE_BARREL
// implement 32 bit barrel shift
// alu_b[6] == 1 ? left(only arithmetic) : right
// alu_b[5] == 1 ? logical : arithmetic
reg        bs_running;
reg [31:0] bs_result;
reg  [4:0] bs_counter;                // 5 bits
wire       bs_left      = alu_b[6];
wire       bs_logical = alu_b[5];
wire [4:0] bs_moves      = alu_b[4:0];
wire       bs_done     = (bs_counter == bs_moves);

always @(posedge clk)
begin
  bs_counter <= 0;
  bs_result  <= alu_a;
  if(bs_running)
  begin
    if(bs_left)      bs_result <= { bs_result[30:0], 1'b0 };                        // shift left
    else
    begin
      if(bs_logical) bs_result <= { 1'b0, bs_result[31:1] };                        // shift logical right
      else           bs_result <= { bs_result[31], bs_result[31], bs_result[30:1] };// shift arithmetic right
    end
    bs_counter <= bs_counter + 1;
  end
end
`endif

// ----- alu add/sub  -----
reg [31:0] alu_b_tmp;
always @(alu_b or alu_op)
begin
  alu_b_tmp <= alu_b;    // by default, ALU_B as is
  if(alu_op == `ALU_PLUS_OFFSET) alu_b_tmp <= { {25{1'b0}}, ~alu_b[4], alu_b[3:0], 2'b0 };    // ALU_B is an offset if ALU_PLUS_OFFSET operation
end

reg [31:0] alu_r_addsub;    // compute R=A+B or A-B based on opcode (ALU_PLUSxx / ALU_SUB-CMP)
always @(alu_a or alu_b_tmp or alu_op)
begin
`ifdef ENABLE_CMP
  if(alu_op == `ALU_CMP_SIGNED || alu_op == `ALU_CMP_UNSIGNED)    // in case of sub or cmp --> operation is '-'
  begin
    alu_r_addsub <= alu_a - alu_b_tmp;
  end
  else
`endif
  begin
    alu_r_addsub <= alu_a + alu_b_tmp;    // by default '+' operation
  end
end

`ifdef ENABLE_CMP
// handle overflow/underflow exceptions in ALU_CMP_SIGNED
reg cmp_exception;
always @(alu_a[31] or alu_b[31] or alu_r_addsub[31])
begin
  cmp_exception <= 0;
  if( (alu_a[31] == 0 && alu_b[31] == 1 && alu_r_addsub[31] == 1) ||
      (alu_a[31] == 1 && alu_b[31] == 0 && alu_r_addsub[31] == 0) ) cmp_exception <= 1;
end
`endif

// ----- alu operation selection -----
always @(alu_a or alu_b or alu_op or flag_idim or alu_r_addsub
`ifdef ENABLE_CMP
        or cmp_exception
`endif
`ifdef ENABLE_MULT
        or mul_done or mul_result
`endif
`ifdef ENABLE_BARREL
        or bs_done or bs_result
`endif
`ifdef ENABLE_DIV
        or div_done or div_result
`endif
)
begin
  done <= 1;        // default alu operations are 1 cycle
`ifdef ENABLE_MULT
  mul_running <= 0;
`endif
`ifdef ENABLE_BARREL
  bs_running <= 0;
`endif
`ifdef ENABLE_DIV
  div_running <= 0;
`endif
  alu_r <= alu_r_addsub;    // ALU_PLUS, ALU_PLUS_OFFSET, ALU_SUB and part of ALU_CMP
  case(alu_op)
    `ALU_NOP        : alu_r <= alu_a;
    `ALU_NOP_B      : alu_r <= alu_b;
    `ALU_AND        : alu_r <= alu_a & alu_b;
    `ALU_OR         : alu_r <= alu_a | alu_b;
    `ALU_NOT        : alu_r <= ~alu_a;
    `ALU_FLIP       : alu_r <= { alu_a[0], alu_a[1], alu_a[2], alu_a[3], alu_a[4], alu_a[5], alu_a[6], alu_a[7],
                                 alu_a[8],alu_a[9],alu_a[10],alu_a[11],alu_a[12],alu_a[13],alu_a[14],alu_a[15],
                                 alu_a[16],alu_a[17],alu_a[18],alu_a[19],alu_a[20],alu_a[21],alu_a[22],alu_a[23],
                                 alu_a[24],alu_a[25],alu_a[26],alu_a[27],alu_a[28],alu_a[29],alu_a[30],alu_a[31] };
    `ALU_IM         : if(flag_idim) alu_r <= { alu_a[24:0], alu_b[6:0] };
                      else          alu_r <= { {25{alu_b[6]}}, alu_b[6:0] };
`ifdef ENABLE_CMP
    `ALU_CMP_UNSIGNED:if( (alu_a[31] == alu_b[31] && cmp_exception) ||
                          (alu_a[31] != alu_b[31] && ~cmp_exception) )
                      begin
                        alu_r[31] <= ~alu_r_addsub[31];
                      end
    `ALU_CMP_SIGNED    : if(cmp_exception)
                      begin
                    alu_r[31] <= ~alu_r_addsub[31];
                      end
`endif
`ifdef ENABLE_XOR
    `ALU_XOR        : alu_r <= alu_a ^ alu_b;
`endif
`ifdef ENABLE_A_SHIFT
    `ALU_A_SHIFT_RIGHT: alu_r <= { alu_a[31], alu_a[31], alu_a[30:1] };    // arithmetic shift left
`endif
`ifdef ENABLE_MULT
    `ALU_MULT         : begin
                        mul_running <= ~mul_done;
                        done         <= mul_done;
                        alu_r         <= mul_result;
                      end
`endif
`ifdef ENABLE_BARREL
    `ALU_BARREL        : begin
                        bs_running <= ~bs_done;
                        done        <= bs_done;
                        alu_r        <= bs_result;
                      end
`endif
`ifdef ENABLE_DIV
    `ALU_DIV        : begin
                        div_running<= ~div_done;
                        done        <= div_done;
                        alu_r        <= quotient;
                      end
    `ALU_MOD        : begin
                        div_running<= ~div_done;
                        done        <= div_done;
                        alu_r        <= qr[31:0];
                      end
`endif
  endcase
end

endmodule
