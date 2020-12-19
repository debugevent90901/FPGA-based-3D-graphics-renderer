// vertex_a, vertex_b, vertex_c: original x, y, z coordinates of a triangle
// V1, v2, V3: coordinates of the triangle after transformation, only x, y matters

module draw(    input [3:0][15:0] vertex_a, vertex_b, vertex_c,
                input [15:0][15:0] model_matrix, view_matrix, projection_matrix,
                input [15:0] width, height,
                output logic [1:0][15:0] V1, V2, V3
);

logic [15:0][15:0] tmp_mvp, mvp;
logic [15:0] x1, y1, w1, x2, y2, w2, x3, y3, w3;
logic [15:0] x1_normalized, y1_normalized, x2_normalized, y2_normalized, x3_normalized, y3_normalized;

logic [15:0] trash0, trash1, trash2;
logic overflow0, overflow1, overflow2, overflow3, overflow4, overflow5, overflow6, overflow7;
logic overflow8, overflow9, overflow10, overflow11, overflow12, overflow13, overflow14, overflow15;
logic overflow16, overflow17, overflow18, overflow19, overflow20, overflow21, overflow22, overflow23;
logic [15:0] tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9, tmp10, tmp11;


matrix_multiplier mm0(.matA(projection_matrix), .matB(view_matrix), .res_mat(tmp_mvp));
matrix_multiplier mm1(.matA(tmp_mvp), .matB(model_matrix), .res_mat(mvp));

dot_product dp00(.a0(mvp[0]), .a1(mvp[1]), .a2(mvp[2]), .a3(mvp[3]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(x1));
dot_product dp01(.a0(mvp[4]), .a1(mvp[5]), .a2(mvp[6]), .a3(mvp[7]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(y1));
dot_product dp02(.a0(mvp[8]), .a1(mvp[9]), .a2(mvp[10]), .a3(mvp[11]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(trash0));
dot_product dp03(.a0(mvp[12]), .a1(mvp[13]), .a2(mvp[14]), .a3(mvp[15]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(w1));

dot_product dp10(.a0(mvp[0]), .a1(mvp[1]), .a2(mvp[2]), .a3(mvp[3]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(x2));
dot_product dp11(.a0(mvp[4]), .a1(mvp[5]), .a2(mvp[6]), .a3(mvp[7]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(y2));
dot_product dp12(.a0(mvp[8]), .a1(mvp[9]), .a2(mvp[10]), .a3(mvp[11]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(trash1));
dot_product dp13(.a0(mvp[12]), .a1(mvp[13]), .a2(mvp[14]), .a3(mvp[15]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(w2));

dot_product dp20(.a0(mvp[0]), .a1(mvp[1]), .a2(mvp[2]), .a3(mvp[3]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(x3));
dot_product dp21(.a0(mvp[4]), .a1(mvp[5]), .a2(mvp[6]), .a3(mvp[7]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(y3));
dot_product dp22(.a0(mvp[8]), .a1(mvp[9]), .a2(mvp[10]), .a3(mvp[11]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(trash2));
dot_product dp23(.a0(mvp[12]), .a1(mvp[13]), .a2(mvp[14]), .a3(mvp[15]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(w3));

fxp_div div0(.dividend(x1), .divisor(w1), .out(x1_normalized), .overflow(overflow0));
fxp_div div1(.dividend(y1), .divisor(w1), .out(y1_normalized), .overflow(overflow1));

fxp_div div2(.dividend(x2), .divisor(w2), .out(x2_normalized), .overflow(overflow2));
fxp_div div3(.dividend(y2), .divisor(w2), .out(y2_normalized), .overflow(overflow3));

fxp_div div4(.dividend(x3), .divisor(w3), .out(x3_normalized), .overflow(overflow4));
fxp_div div5(.dividend(y3), .divisor(w3), .out(y3_normalized), .overflow(overflow5));
// above pass testbench, correct

fxp_add add0(.ina(x1_normalized), .inb(16'h0100), .out(tmp0), .overflow(overflow6));
fxp_mul mul0(.ina(width), .inb(tmp0), .out(tmp1), .overflow(overflow7));
fxp_div div6 (
    .dividend(tmp1), 
    .divisor(16'h0200), 
    .out(V1[0]), 
    .overflow(overflow8)
);
fxp_add add1(.ina(y1_normalized), .inb(16'h0100), .out(tmp2), .overflow(overflow9));
fxp_mul mul2(.ina(height), .inb(tmp2), .out(tmp3), .overflow(overflow10));
fxp_div div7 (
    .dividend(tmp3), 
    .divisor(16'h0200), 
    .out(V1[1]), 
    .overflow(overflow11)
);

fxp_add add2(.ina(x2_normalized), .inb(16'h0100), .out(tmp4), .overflow(overflow12));
fxp_mul mul4(.ina(width), .inb(tmp4), .out(tmp5), .overflow(overflow13));
fxp_div div8 (
    .dividend(tmp5), 
    .divisor(16'h0200), 
    .out(V2[0]), 
    .overflow(overflow14)
);
fxp_add add3(.ina(y2_normalized), .inb(16'h0100), .out(tmp6), .overflow(overflow15));
fxp_mul mul6(.ina(height), .inb(tmp6), .out(tmp7), .overflow(overflow16));
fxp_div div9 (
    .dividend(tmp7), 
    .divisor(16'h0200), 
    .out(V2[1]), 
    .overflow(overflow17)
);

fxp_add add4(.ina(x3_normalized), .inb(16'h0100), .out(tmp8), .overflow(overflow18));
fxp_mul mul8(.ina(width), .inb(tmp8), .out(tmp9), .overflow(overflow19));
fxp_div div10 (
    .dividend(tmp9), 
    .divisor(16'h0200), 
    .out(V3[0]), 
    .overflow(overflow20)
);
fxp_add add5(.ina(y3_normalized), .inb(16'h0100), .out(tmp10), .overflow(overflow21));
fxp_mul mul10(.ina(height), .inb(tmp10), .out(tmp11), .overflow(overflow22));
fxp_div div11 (
    .dividend(tmp11),
    .divisor(16'h0200), 
    .out(V3[1]), 
    .overflow(overflow23)
);

endmodule