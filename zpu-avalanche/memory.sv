//
// 1Mword of 32-bit RAM.
//
// Copyright (c) 2018 Serge Vakulenko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
`default_nettype none

module memory(
    input  wire         clk,            // clock
    input  wire  [19:0] i_addr,         // address input
    input  wire         i_read,         // read op
    input  wire         i_write,        // write op
    input  wire  [31:0] i_data,         // data to memory
    output logic [31:0] o_data,         // data from memory
    output logic        o_done          // write op
);

// Global time parameters.
timeunit 1ns / 1ps;

logic [31:0] mem[1024*1024];            // main RAM

always @(posedge clk) begin
    if (i_read) begin
        o_data <= mem[i_addr];          // memory load
        $display("read %h -> %h", i_addr, mem[i_addr]);
    end

    if (i_write) begin
        mem[i_addr] <= i_data;          // memory store
        $display("write %h := %h", i_addr, i_data);
    end

    o_done <= i_read | i_write;
end

initial begin
    mem['h20 +   0] = 'h0b0b0b88;
    mem['h20 +   1] = 'he5040000;
    mem['h20 +   2] = 'h00000000;
    mem['h20 +   3] = 'h00000000;
    mem['h20 +   4] = 'h00000000;
    mem['h20 +   5] = 'h00000000;
    mem['h20 +   6] = 'h00000000;
    mem['h20 +   7] = 'h00000000;
    mem['h20 +   8] = 'h88088c08;
    mem['h20 +   9] = 'h90080b0b;
    mem['h20 +  10] = 'h0b88e108;
    mem['h20 +  11] = 'h2d900c8c;
    mem['h20 +  12] = 'h0c880c04;
    mem['h20 +  13] = 'h00000000;
    mem['h20 +  14] = 'h00000000;
    mem['h20 +  15] = 'h00000000;
    mem['h20 +  16] = 'h71fd0608;
    mem['h20 +  17] = 'h72830609;
    mem['h20 +  18] = 'h81058205;
    mem['h20 +  19] = 'h832b2a83;
    mem['h20 +  20] = 'hffff0652;
    mem['h20 +  21] = 'h04000000;
    mem['h20 +  22] = 'h00000000;
    mem['h20 +  23] = 'h00000000;
    mem['h20 +  24] = 'h71fd0608;
    mem['h20 +  25] = 'h83ffff73;
    mem['h20 +  26] = 'h83060981;
    mem['h20 +  27] = 'h05820583;
    mem['h20 +  28] = 'h2b2b0906;
    mem['h20 +  29] = 'h7383ffff;
    mem['h20 +  30] = 'h0b0b0b0b;
    mem['h20 +  31] = 'h83a50400;
    mem['h20 +  32] = 'h72098105;
    mem['h20 +  33] = 'h72057373;
    mem['h20 +  34] = 'h09060906;
    mem['h20 +  35] = 'h73097306;
    mem['h20 +  36] = 'h070a8106;
    mem['h20 +  37] = 'h53510400;
    mem['h20 +  38] = 'h00000000;
    mem['h20 +  39] = 'h00000000;
    mem['h20 +  40] = 'h72722473;
    mem['h20 +  41] = 'h732e0753;
    mem['h20 +  42] = 'h51040000;
    mem['h20 +  43] = 'h00000000;
    mem['h20 +  44] = 'h00000000;
    mem['h20 +  45] = 'h00000000;
    mem['h20 +  46] = 'h00000000;
    mem['h20 +  47] = 'h00000000;
    mem['h20 +  48] = 'h71737109;
    mem['h20 +  49] = 'h71068106;
    mem['h20 +  50] = 'h09810572;
    mem['h20 +  51] = 'h0a100a72;
    mem['h20 +  52] = 'h0a100a31;
    mem['h20 +  53] = 'h050a8106;
    mem['h20 +  54] = 'h51515351;
    mem['h20 +  55] = 'h04000000;
    mem['h20 +  56] = 'h72722673;
    mem['h20 +  57] = 'h732e0753;
    mem['h20 +  58] = 'h51040000;
    mem['h20 +  59] = 'h00000000;
    mem['h20 +  60] = 'h00000000;
    mem['h20 +  61] = 'h00000000;
    mem['h20 +  62] = 'h00000000;
    mem['h20 +  63] = 'h00000000;
    mem['h20 +  64] = 'h00000000;
    mem['h20 +  65] = 'h00000000;
    mem['h20 +  66] = 'h00000000;
    mem['h20 +  67] = 'h00000000;
    mem['h20 +  68] = 'h00000000;
    mem['h20 +  69] = 'h00000000;
    mem['h20 +  70] = 'h00000000;
    mem['h20 +  71] = 'h00000000;
    mem['h20 +  72] = 'h0b0b0b88;
    mem['h20 +  73] = 'hba040000;
    mem['h20 +  74] = 'h00000000;
    mem['h20 +  75] = 'h00000000;
    mem['h20 +  76] = 'h00000000;
    mem['h20 +  77] = 'h00000000;
    mem['h20 +  78] = 'h00000000;
    mem['h20 +  79] = 'h00000000;
    mem['h20 +  80] = 'h720a722b;
    mem['h20 +  81] = 'h0a535104;
    mem['h20 +  82] = 'h00000000;
    mem['h20 +  83] = 'h00000000;
    mem['h20 +  84] = 'h00000000;
    mem['h20 +  85] = 'h00000000;
    mem['h20 +  86] = 'h00000000;
    mem['h20 +  87] = 'h00000000;
    mem['h20 +  88] = 'h72729f06;
    mem['h20 +  89] = 'h0981050b;
    mem['h20 +  90] = 'h0b0b889f;
    mem['h20 +  91] = 'h05040000;
    mem['h20 +  92] = 'h00000000;
    mem['h20 +  93] = 'h00000000;
    mem['h20 +  94] = 'h00000000;
    mem['h20 +  95] = 'h00000000;
    mem['h20 +  96] = 'h72722aff;
    mem['h20 +  97] = 'h739f062a;
    mem['h20 +  98] = 'h0974090a;
    mem['h20 +  99] = 'h8106ff05;
    mem['h20 + 100] = 'h06075351;
    mem['h20 + 101] = 'h04000000;
    mem['h20 + 102] = 'h00000000;
    mem['h20 + 103] = 'h00000000;
    mem['h20 + 104] = 'h71715351;
    mem['h20 + 105] = 'h04067383;
    mem['h20 + 106] = 'h06098105;
    mem['h20 + 107] = 'h8205832b;
    mem['h20 + 108] = 'h0b2b0772;
    mem['h20 + 109] = 'hfc060c51;
    mem['h20 + 110] = 'h51040000;
    mem['h20 + 111] = 'h00000000;
    mem['h20 + 112] = 'h72098105;
    mem['h20 + 113] = 'h72050970;
    mem['h20 + 114] = 'h81050906;
    mem['h20 + 115] = 'h0a810653;
    mem['h20 + 116] = 'h51040000;
    mem['h20 + 117] = 'h00000000;
    mem['h20 + 118] = 'h00000000;
    mem['h20 + 119] = 'h00000000;
    mem['h20 + 120] = 'h72098105;
    mem['h20 + 121] = 'h72050970;
    mem['h20 + 122] = 'h81050906;
    mem['h20 + 123] = 'h0a098106;
    mem['h20 + 124] = 'h53510400;
    mem['h20 + 125] = 'h00000000;
    mem['h20 + 126] = 'h00000000;
    mem['h20 + 127] = 'h00000000;
    mem['h20 + 128] = 'h71098105;
    mem['h20 + 129] = 'h52040000;
    mem['h20 + 130] = 'h00000000;
    mem['h20 + 131] = 'h00000000;
    mem['h20 + 132] = 'h00000000;
    mem['h20 + 133] = 'h00000000;
    mem['h20 + 134] = 'h00000000;
    mem['h20 + 135] = 'h00000000;
    mem['h20 + 136] = 'h72720981;
    mem['h20 + 137] = 'h05055351;
    mem['h20 + 138] = 'h04000000;
    mem['h20 + 139] = 'h00000000;
    mem['h20 + 140] = 'h00000000;
    mem['h20 + 141] = 'h00000000;
    mem['h20 + 142] = 'h00000000;
    mem['h20 + 143] = 'h00000000;
    mem['h20 + 144] = 'h72097206;
    mem['h20 + 145] = 'h73730906;
    mem['h20 + 146] = 'h07535104;
    mem['h20 + 147] = 'h00000000;
    mem['h20 + 148] = 'h00000000;
    mem['h20 + 149] = 'h00000000;
    mem['h20 + 150] = 'h00000000;
    mem['h20 + 151] = 'h00000000;
    mem['h20 + 152] = 'h71fc0608;
    mem['h20 + 153] = 'h72830609;
    mem['h20 + 154] = 'h81058305;
    mem['h20 + 155] = 'h1010102a;
    mem['h20 + 156] = 'h81ff0652;
    mem['h20 + 157] = 'h04000000;
    mem['h20 + 158] = 'h00000000;
    mem['h20 + 159] = 'h00000000;
    mem['h20 + 160] = 'h71fc0608;
    mem['h20 + 161] = 'h0b0b0b8d;
    mem['h20 + 162] = 'he4738306;
    mem['h20 + 163] = 'h10100508;
    mem['h20 + 164] = 'h060b0b0b;
    mem['h20 + 165] = 'h88a20400;
    mem['h20 + 166] = 'h00000000;
    mem['h20 + 167] = 'h00000000;
    mem['h20 + 168] = 'h88088c08;
    mem['h20 + 169] = 'h90087575;
    mem['h20 + 170] = 'h0b0b0b89;
    mem['h20 + 171] = 'he52d5050;
    mem['h20 + 172] = 'h88085690;
    mem['h20 + 173] = 'h0c8c0c88;
    mem['h20 + 174] = 'h0c510400;
    mem['h20 + 175] = 'h00000000;
    mem['h20 + 176] = 'h88088c08;
    mem['h20 + 177] = 'h90087575;
    mem['h20 + 178] = 'h0b0b0b8b;
    mem['h20 + 179] = 'h972d5050;
    mem['h20 + 180] = 'h88085690;
    mem['h20 + 181] = 'h0c8c0c88;
    mem['h20 + 182] = 'h0c510400;
    mem['h20 + 183] = 'h00000000;
    mem['h20 + 184] = 'h72097081;
    mem['h20 + 185] = 'h0509060a;
    mem['h20 + 186] = 'h8106ff05;
    mem['h20 + 187] = 'h70547106;
    mem['h20 + 188] = 'h73097274;
    mem['h20 + 189] = 'h05ff0506;
    mem['h20 + 190] = 'h07515151;
    mem['h20 + 191] = 'h04000000;
    mem['h20 + 192] = 'h72097081;
    mem['h20 + 193] = 'h0509060a;
    mem['h20 + 194] = 'h098106ff;
    mem['h20 + 195] = 'h05705471;
    mem['h20 + 196] = 'h06730972;
    mem['h20 + 197] = 'h7405ff05;
    mem['h20 + 198] = 'h06075151;
    mem['h20 + 199] = 'h51040000;
    mem['h20 + 200] = 'h05ff0504;
    mem['h20 + 201] = 'h00000000;
    mem['h20 + 202] = 'h00000000;
    mem['h20 + 203] = 'h00000000;
    mem['h20 + 204] = 'h00000000;
    mem['h20 + 205] = 'h00000000;
    mem['h20 + 206] = 'h00000000;
    mem['h20 + 207] = 'h00000000;
    mem['h20 + 208] = 'h04000000;
    mem['h20 + 209] = 'h00000000;
    mem['h20 + 210] = 'h00000000;
    mem['h20 + 211] = 'h00000000;
    mem['h20 + 212] = 'h00000000;
    mem['h20 + 213] = 'h00000000;
    mem['h20 + 214] = 'h00000000;
    mem['h20 + 215] = 'h00000000;
    mem['h20 + 216] = 'h71810552;
    mem['h20 + 217] = 'h04000000;
    mem['h20 + 218] = 'h00000000;
    mem['h20 + 219] = 'h00000000;
    mem['h20 + 220] = 'h00000000;
    mem['h20 + 221] = 'h00000000;
    mem['h20 + 222] = 'h00000000;
    mem['h20 + 223] = 'h00000000;
    mem['h20 + 224] = 'h04000000;
    mem['h20 + 225] = 'h00000000;
    mem['h20 + 226] = 'h00000000;
    mem['h20 + 227] = 'h00000000;
    mem['h20 + 228] = 'h00000000;
    mem['h20 + 229] = 'h00000000;
    mem['h20 + 230] = 'h00000000;
    mem['h20 + 231] = 'h00000000;
    mem['h20 + 232] = 'h02840572;
    mem['h20 + 233] = 'h10100552;
    mem['h20 + 234] = 'h04000000;
    mem['h20 + 235] = 'h00000000;
    mem['h20 + 236] = 'h00000000;
    mem['h20 + 237] = 'h00000000;
    mem['h20 + 238] = 'h00000000;
    mem['h20 + 239] = 'h00000000;
    mem['h20 + 240] = 'h00000000;
    mem['h20 + 241] = 'h00000000;
    mem['h20 + 242] = 'h00000000;
    mem['h20 + 243] = 'h00000000;
    mem['h20 + 244] = 'h00000000;
    mem['h20 + 245] = 'h00000000;
    mem['h20 + 246] = 'h00000000;
    mem['h20 + 247] = 'h00000000;
    mem['h20 + 248] = 'h717105ff;
    mem['h20 + 249] = 'h05715351;
    mem['h20 + 250] = 'h020d0400;
    mem['h20 + 251] = 'h00000000;
    mem['h20 + 252] = 'h00000000;
    mem['h20 + 253] = 'h00000000;
    mem['h20 + 254] = 'h00000000;
    mem['h20 + 255] = 'h00000000;
    mem['h20 + 256] = 'h10101010;
    mem['h20 + 257] = 'h10101010;
    mem['h20 + 258] = 'h10101010;
    mem['h20 + 259] = 'h10101010;
    mem['h20 + 260] = 'h10101010;
    mem['h20 + 261] = 'h10101010;
    mem['h20 + 262] = 'h10101010;
    mem['h20 + 263] = 'h10101053;
    mem['h20 + 264] = 'h51047381;
    mem['h20 + 265] = 'hff067383;
    mem['h20 + 266] = 'h06098105;
    mem['h20 + 267] = 'h83051010;
    mem['h20 + 268] = 'h102b0772;
    mem['h20 + 269] = 'hfc060c51;
    mem['h20 + 270] = 'h51047272;
    mem['h20 + 271] = 'h80728106;
    mem['h20 + 272] = 'hff050972;
    mem['h20 + 273] = 'h06057110;
    mem['h20 + 274] = 'h52720a10;
    mem['h20 + 275] = 'h0a5372ed;
    mem['h20 + 276] = 'h38515153;
    mem['h20 + 277] = 'h51040000;
    mem['h20 + 278] = 'h80040088;
    mem['h20 + 279] = 'hda040400;
    mem['h20 + 280] = 'h00000004;
    mem['h20 + 281] = 'h5e8e8470;
    mem['h20 + 282] = 'h8e84278b;
    mem['h20 + 283] = 'h38807170;
    mem['h20 + 284] = 'h8405530c;
    mem['h20 + 285] = 'h88e70488;
    mem['h20 + 286] = 'hda5188fd;
    mem['h20 + 287] = 'h04803d0d;
    mem['h20 + 288] = 'h8df451a8;
    mem['h20 + 289] = 'h3f800b88;
    mem['h20 + 290] = 'h0c823d0d;
    mem['h20 + 291] = 'h04ff3d0d;
    mem['h20 + 292] = 'h7352c008;
    mem['h20 + 293] = 'h70882a70;
    mem['h20 + 294] = 'h81065151;
    mem['h20 + 295] = 'h5170802e;
    mem['h20 + 296] = 'hf13871c0;
    mem['h20 + 297] = 'h0c71880c;
    mem['h20 + 298] = 'h833d0d04;
    mem['h20 + 299] = 'hfd3d0d75;
    mem['h20 + 300] = 'h53723370;
    mem['h20 + 301] = 'h81ff0652;
    mem['h20 + 302] = 'h5270802e;
    mem['h20 + 303] = 'ha1387181;
    mem['h20 + 304] = 'hff068114;
    mem['h20 + 305] = 'h5452c008;
    mem['h20 + 306] = 'h70882a70;
    mem['h20 + 307] = 'h81065151;
    mem['h20 + 308] = 'h5170802e;
    mem['h20 + 309] = 'hf13871c0;
    mem['h20 + 310] = 'h0c811454;
    mem['h20 + 311] = 'hd4397388;
    mem['h20 + 312] = 'h0c853d0d;
    mem['h20 + 313] = 'h04940802;
    mem['h20 + 314] = 'h940cf93d;
    mem['h20 + 315] = 'h0d800b94;
    mem['h20 + 316] = 'h08fc050c;
    mem['h20 + 317] = 'h94088805;
    mem['h20 + 318] = 'h088025ab;
    mem['h20 + 319] = 'h38940888;
    mem['h20 + 320] = 'h05083094;
    mem['h20 + 321] = 'h0888050c;
    mem['h20 + 322] = 'h800b9408;
    mem['h20 + 323] = 'hf4050c94;
    mem['h20 + 324] = 'h08fc0508;
    mem['h20 + 325] = 'h8838810b;
    mem['h20 + 326] = 'h9408f405;
    mem['h20 + 327] = 'h0c9408f4;
    mem['h20 + 328] = 'h05089408;
    mem['h20 + 329] = 'hfc050c94;
    mem['h20 + 330] = 'h088c0508;
    mem['h20 + 331] = 'h8025ab38;
    mem['h20 + 332] = 'h94088c05;
    mem['h20 + 333] = 'h08309408;
    mem['h20 + 334] = 'h8c050c80;
    mem['h20 + 335] = 'h0b9408f0;
    mem['h20 + 336] = 'h050c9408;
    mem['h20 + 337] = 'hfc050888;
    mem['h20 + 338] = 'h38810b94;
    mem['h20 + 339] = 'h08f0050c;
    mem['h20 + 340] = 'h9408f005;
    mem['h20 + 341] = 'h089408fc;
    mem['h20 + 342] = 'h050c8053;
    mem['h20 + 343] = 'h94088c05;
    mem['h20 + 344] = 'h08529408;
    mem['h20 + 345] = 'h88050851;
    mem['h20 + 346] = 'h81a73f88;
    mem['h20 + 347] = 'h08709408;
    mem['h20 + 348] = 'hf8050c54;
    mem['h20 + 349] = 'h9408fc05;
    mem['h20 + 350] = 'h08802e8c;
    mem['h20 + 351] = 'h389408f8;
    mem['h20 + 352] = 'h05083094;
    mem['h20 + 353] = 'h08f8050c;
    mem['h20 + 354] = 'h9408f805;
    mem['h20 + 355] = 'h0870880c;
    mem['h20 + 356] = 'h54893d0d;
    mem['h20 + 357] = 'h940c0494;
    mem['h20 + 358] = 'h0802940c;
    mem['h20 + 359] = 'hfb3d0d80;
    mem['h20 + 360] = 'h0b9408fc;
    mem['h20 + 361] = 'h050c9408;
    mem['h20 + 362] = 'h88050880;
    mem['h20 + 363] = 'h25933894;
    mem['h20 + 364] = 'h08880508;
    mem['h20 + 365] = 'h30940888;
    mem['h20 + 366] = 'h050c810b;
    mem['h20 + 367] = 'h9408fc05;
    mem['h20 + 368] = 'h0c94088c;
    mem['h20 + 369] = 'h05088025;
    mem['h20 + 370] = 'h8c389408;
    mem['h20 + 371] = 'h8c050830;
    mem['h20 + 372] = 'h94088c05;
    mem['h20 + 373] = 'h0c815394;
    mem['h20 + 374] = 'h088c0508;
    mem['h20 + 375] = 'h52940888;
    mem['h20 + 376] = 'h050851ad;
    mem['h20 + 377] = 'h3f880870;
    mem['h20 + 378] = 'h9408f805;
    mem['h20 + 379] = 'h0c549408;
    mem['h20 + 380] = 'hfc050880;
    mem['h20 + 381] = 'h2e8c3894;
    mem['h20 + 382] = 'h08f80508;
    mem['h20 + 383] = 'h309408f8;
    mem['h20 + 384] = 'h050c9408;
    mem['h20 + 385] = 'hf8050870;
    mem['h20 + 386] = 'h880c5487;
    mem['h20 + 387] = 'h3d0d940c;
    mem['h20 + 388] = 'h04940802;
    mem['h20 + 389] = 'h940cfd3d;
    mem['h20 + 390] = 'h0d810b94;
    mem['h20 + 391] = 'h08fc050c;
    mem['h20 + 392] = 'h800b9408;
    mem['h20 + 393] = 'hf8050c94;
    mem['h20 + 394] = 'h088c0508;
    mem['h20 + 395] = 'h94088805;
    mem['h20 + 396] = 'h0827ac38;
    mem['h20 + 397] = 'h9408fc05;
    mem['h20 + 398] = 'h08802ea3;
    mem['h20 + 399] = 'h38800b94;
    mem['h20 + 400] = 'h088c0508;
    mem['h20 + 401] = 'h24993894;
    mem['h20 + 402] = 'h088c0508;
    mem['h20 + 403] = 'h1094088c;
    mem['h20 + 404] = 'h050c9408;
    mem['h20 + 405] = 'hfc050810;
    mem['h20 + 406] = 'h9408fc05;
    mem['h20 + 407] = 'h0cc93994;
    mem['h20 + 408] = 'h08fc0508;
    mem['h20 + 409] = 'h802e80c9;
    mem['h20 + 410] = 'h3894088c;
    mem['h20 + 411] = 'h05089408;
    mem['h20 + 412] = 'h88050826;
    mem['h20 + 413] = 'ha1389408;
    mem['h20 + 414] = 'h88050894;
    mem['h20 + 415] = 'h088c0508;
    mem['h20 + 416] = 'h31940888;
    mem['h20 + 417] = 'h050c9408;
    mem['h20 + 418] = 'hf8050894;
    mem['h20 + 419] = 'h08fc0508;
    mem['h20 + 420] = 'h079408f8;
    mem['h20 + 421] = 'h050c9408;
    mem['h20 + 422] = 'hfc050881;
    mem['h20 + 423] = 'h2a9408fc;
    mem['h20 + 424] = 'h050c9408;
    mem['h20 + 425] = 'h8c050881;
    mem['h20 + 426] = 'h2a94088c;
    mem['h20 + 427] = 'h050cffaf;
    mem['h20 + 428] = 'h39940890;
    mem['h20 + 429] = 'h0508802e;
    mem['h20 + 430] = 'h8f389408;
    mem['h20 + 431] = 'h88050870;
    mem['h20 + 432] = 'h9408f405;
    mem['h20 + 433] = 'h0c518d39;
    mem['h20 + 434] = 'h9408f805;
    mem['h20 + 435] = 'h08709408;
    mem['h20 + 436] = 'hf4050c51;
    mem['h20 + 437] = 'h9408f405;
    mem['h20 + 438] = 'h08880c85;
    mem['h20 + 439] = 'h3d0d940c;
    mem['h20 + 440] = 'h04000000;
    mem['h20 + 441] = 'h00ffffff;
    mem['h20 + 442] = 'hff00ffff;
    mem['h20 + 443] = 'hffff00ff;
    mem['h20 + 444] = 'hffffff00;
    mem['h20 + 445] = 'h48656c6c;
    mem['h20 + 446] = 'h6f2c2077;
    mem['h20 + 447] = 'h6f726c64;
    mem['h20 + 448] = 'h210a0064;
end

endmodule
