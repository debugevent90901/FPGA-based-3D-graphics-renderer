// 4x4 fixed-point number matrix multiplication
// each fixed-point number is 16-bit
// a matrix 4x4, each 16-bit = 256-bit

module matrix_multiplier_parallel_pro(  input [255:0] matA, matB,
                                        output logic    [255:0] res_mat,
);

dot_product dp0(.vectorA(matA[15:0]), .vectorB(matB[15:0]), .res(res_mat[15:0]));
dot_product dp1(.vectorA(matA[31:16]), .vectorB(matB[31:16]), .res(res_mat[31:16]));
dot_product dp2(.vectorA(matA[47:32]), .vectorB(matB[47:32]), .res(res_mat[47:32]));
dot_product dp3(.vectorA(matA[63:48]), .vectorB(matB[63:48]), .res(res_mat[63:48]));
dot_product dp4(.vectorA(matA[79:64]), .vectorB(matB[79:64]), .res(res_mat[79:64]));
dot_product dp5(.vectorA(matA[95:80]), .vectorB(matB[95:80]), .res(res_mat[95:80]));
dot_product dp6(.vectorA(matA[111:96]), .vectorB(matB[111:96]), .res(res_mat[111:96]));
dot_product dp7(.vectorA(matA[127:112]), .vectorB(matB[127:112]), .res(res_mat[127:112]));
dot_product dp8(.vectorA(matA[143:128]), .vectorB(matB[143:128]), .res(res_mat[143:128]));
dot_product dp9(.vectorA(matA[159:144]), .vectorB(matB[159:144]), .res(res_mat[159:144]));
dot_product dp10(.vectorA(matA[175:160]), .vectorB(matB[175:160]), .res(res_mat[175:160]));
dot_product dp11(.vectorA(matA[191:176]), .vectorB(matB[191:176]), .res(res_mat[191:176]));
dot_product dp12(.vectorA(matA[207:192]), .vectorB(matB[207:192]), .res(res_mat[207:192]));
dot_product dp13(.vectorA(matA[223:208]), .vectorB(matB[223:208]), .res(res_mat[223:208]));
dot_product dp14(.vectorA(matA[239:224]), .vectorB(matB[239:224]), .res(res_mat[239:224]));
dot_product dp15(.vectorA(matA[255:240]), .vectorB(matB[255:240]), .res(res_mat[255:240]));

endmodule






module dot_product( input [63:0] vectorA, vectorB,
                    output logic    [15:0] res,
);

logic [15:0] mul_res0, mul_res1, mul_res2, mul_res3;
logic [15:0] add_tmp0, add_tmp1;
logic mul_overflow0, mul_overflow1, mul_overflow2, mul_overflow3;
logic add_overflow0, add_overflow1, add_overflow2;

fxp_mul mul0(.ina(vectorA[15:0]), .inb(vectorB[15:0]), .out(mul_res0), .overflow(overflow0));
fxp_mul mul1(.ina(vectorA[31:16]), .inb(vectorB[31:16]), .out(mul_res1), .overflow(overflow1));
fxp_mul mul2(.ina(vectorA[47:32]), .inb(vectorB[47:32]), .out(mul_res2), .overflow(overflow2));
fxp_mul mul3(.ina(vectorA[63:48]), .inb(vectorB[63:48]), .out(mul_res3), .overflow(overflow3));

fxp_add add0(.ina(mul_res0), .inb(mul_res1), .out(add_tmp0), .overflow(add_overflow0));
fxp_add add1(.ina(add_tmp0), .inb(mul_res2), .out(add_tmp1), .overflow(add_overflow1));
fxp_add add2(.ina(add_tmp1), .inb(mul_res3), .out(res), .overflow(add_overflow2));

endmodule





module matrix_multiplier_parallel(   input Clk, Reset, matrix_multiplier_start,
                            input           [255:0] matA, matB,
                            output logic    [255:0] res_mat,
                            output logic matrix_multiplier_done
);

dot_product dp0 ;
dot_product dp1 ;
dot_product dp2 ;
dot_product dp3 ;

endmodule