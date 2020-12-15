// 4x4 fixed-point number matrix multiplication
// each fixed-point number is 16-bit
// a matrix 4x4, each 16-bit = 256-bit

// 16 x 16-bit matrix indices
// 0   1   2   3
// 4   5   6   7  
// 8   9   10  11
// 12  13  14  15

module matrix_multiplier(  input           [15:0][15:0] matA, matB,
                                        output logic    [15:0][15:0] res_mat
);

dot_product dp0(.a0(matA[0]), .a1(matA[1]), .a2(matA[2]), .a3(matA[3]), .b0(matB[0]), .b1(matB[4]), .b2(matB[8]), .b3(matB[12]), .res(res_mat[0]));
dot_product dp1(.a0(matA[0]), .a1(matA[1]), .a2(matA[2]), .a3(matA[3]), .b0(matB[1]), .b1(matB[5]), .b2(matB[9]), .b3(matB[13]), .res(res_mat[1]));
dot_product dp2(.a0(matA[0]), .a1(matA[1]), .a2(matA[2]), .a3(matA[3]), .b0(matB[2]), .b1(matB[6]), .b2(matB[10]), .b3(matB[14]), .res(res_mat[2]));
dot_product dp3(.a0(matA[0]), .a1(matA[1]), .a2(matA[2]), .a3(matA[3]), .b0(matB[3]), .b1(matB[7]), .b2(matB[11]), .b3(matB[15]), .res(res_mat[3]));

dot_product dp4(.a0(matA[4]), .a1(matA[5]), .a2(matA[6]), .a3(matA[7]), .b0(matB[0]), .b1(matB[4]), .b2(matB[8]), .b3(matB[12]), .res(res_mat[4]));
dot_product dp5(.a0(matA[4]), .a1(matA[5]), .a2(matA[6]), .a3(matA[7]), .b0(matB[1]), .b1(matB[5]), .b2(matB[9]), .b3(matB[13]), .res(res_mat[5]));
dot_product dp6(.a0(matA[4]), .a1(matA[5]), .a2(matA[6]), .a3(matA[7]), .b0(matB[2]), .b1(matB[6]), .b2(matB[10]), .b3(matB[14]), .res(res_mat[6]));
dot_product dp7(.a0(matA[4]), .a1(matA[5]), .a2(matA[6]), .a3(matA[7]), .b0(matB[3]), .b1(matB[7]), .b2(matB[11]), .b3(matB[15]), .res(res_mat[7]));

dot_product dp8(.a0(matA[8]), .a1(matA[9]), .a2(matA[10]), .a3(matA[11]), .b0(matB[0]), .b1(matB[4]), .b2(matB[8]), .b3(matB[12]), .res(res_mat[8]));
dot_product dp9(.a0(matA[8]), .a1(matA[9]), .a2(matA[10]), .a3(matA[11]), .b0(matB[1]), .b1(matB[5]), .b2(matB[9]), .b3(matB[13]), .res(res_mat[9]));
dot_product dp10(.a0(matA[8]), .a1(matA[9]), .a2(matA[10]), .a3(matA[11]), .b0(matB[2]), .b1(matB[6]), .b2(matB[10]), .b3(matB[14]), .res(res_mat[10]));
dot_product dp11(.a0(matA[8]), .a1(matA[9]), .a2(matA[10]), .a3(matA[11]), .b0(matB[3]), .b1(matB[7]), .b2(matB[11]), .b3(matB[15]), .res(res_mat[11]));

dot_product dp12(.a0(matA[12]), .a1(matA[13]), .a2(matA[14]), .a3(matA[15]), .b0(matB[0]), .b1(matB[4]), .b2(matB[8]), .b3(matB[12]), .res(res_mat[12]));
dot_product dp13(.a0(matA[12]), .a1(matA[13]), .a2(matA[14]), .a3(matA[15]), .b0(matB[1]), .b1(matB[5]), .b2(matB[9]), .b3(matB[13]), .res(res_mat[13]));
dot_product dp14(.a0(matA[12]), .a1(matA[13]), .a2(matA[14]), .a3(matA[15]), .b0(matB[2]), .b1(matB[6]), .b2(matB[10]), .b3(matB[14]), .res(res_mat[14]));
dot_product dp15(.a0(matA[12]), .a1(matA[13]), .a2(matA[14]), .a3(matA[15]), .b0(matB[3]), .b1(matB[7]), .b2(matB[11]), .b3(matB[15]), .res(res_mat[15]));

endmodule






module dot_product( input [16:0] a0, a1, a2, a3, b0, b1, b2, b3,
                    output logic    [15:0] res
);

logic [15:0] mul_res0, mul_res1, mul_res2, mul_res3;
logic [15:0] add_tmp0, add_tmp1;
logic mul_overflow0, mul_overflow1, mul_overflow2, mul_overflow3;
logic add_overflow0, add_overflow1, add_overflow2;

fxp_mul mul0(.ina(a0), .inb(b0), .out(mul_res0), .overflow(overflow0));
fxp_mul mul1(.ina(a1), .inb(b1), .out(mul_res1), .overflow(overflow1));
fxp_mul mul2(.ina(a2), .inb(b2), .out(mul_res2), .overflow(overflow2));
fxp_mul mul3(.ina(a3), .inb(b3), .out(mul_res3), .overflow(overflow3));

fxp_add add0(.ina(mul_res0), .inb(mul_res1), .out(add_tmp0), .overflow(add_overflow0));
fxp_add add1(.ina(add_tmp0), .inb(mul_res2), .out(add_tmp1), .overflow(add_overflow1));
fxp_add add2(.ina(add_tmp1), .inb(mul_res3), .out(res), .overflow(add_overflow2));

endmodule