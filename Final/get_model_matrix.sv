// [ scale*cos(angle),     0, scale*sin(angle), x]
// [                0, scale,                0, y]
// [-scale*sin(angle),     0, scale*cos(angle), z]
// [                0,     0,                0, 1]

// 3.1415926 = 00000011.00100100 = 0324
// 1.5707963 = 1.921fb4d12d84a

/* module get_model_matrix # (
    // angle
    parameter WIIA = 4,
    parameter WIFA = 8,
    // scale, x_translate, y_translate, z_translate
    parameter WIIB = 8,
    parameter WIFB = 8,
    // output of sin, cos
    parameter WOIA = 2,
    parameter WOFA = 12,
    // output matrix
    parameter WOIB = 8,
    parameter WOFB = 8
)
(   input [WIIA+WIFA-1:0] angle,
    input [WIIB+WIFB-1:0] scale, x_translate, y_translate, z_translate,
    output logic [15:0][WOIB+WOFB-1:0] model_matrix
);

logic [WIIA+WIFA-1:0] pi_div_2_sub_angle;
logic [WOIA+WOFA-1:0] sin_angle, cos_angle; 
logic [WOIB+WOFB-1:0] s_m_c, s_m_s, neg_s_m_s;
logic overflow0, overflow1, overflow2, overflow3, overflow4, overflow5, overflow6, overflow7;
logic [WOIB+WOFB-1:0] zero, one;

fxp_addsub #(   
    .WIIA(4), .WIFA(8),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) cos_to_sin (
    .ina(12'h192), 
    .inb(angle), 
    .sub(1'b1), 
    .out(pi_div_2_sub_angle), 
    .overflow(overflow0)
);

fxp_sin #(
    .WII(WIIA),
    .WIF(WIFA),
    .WOI(WOIA),
    .WOF(WOFA),
    .ROUND(1)
) sin ( 
    .in(angle), 
    .out(sin_angle), 
    .i_overflow(overflow1)
);
fxp_sin # (
    .WII(WIIA),
    .WIF(WIFA),
    .WOI(WOIA),
    .WOF(WOFA),
    .ROUND(1)
) cos (
    .in(pi_div_2_sub_angle), 
    .out(cos_angle), 
    .i_overflow(overflow2)
);

fxp_mul #(  
    .WIIA(WIIB),   .WIFA(WIFB),
    .WIIB(WOIA),   .WIFB(WOFA),
    .WOI(WOIB),    .WOF(WOFB)
) scale_mul_cos (
    .ina(scale), 
    .inb(cos_angle), 
    .out(s_m_c), 
    .overflow(overflow3)
);

fxp_mul #(  
    .WIIA(WIIB),   .WIFA(WIFB),
    .WIIB(WOIA),   .WIFB(WOFA),
    .WOI(WOIB),    .WOF(WOFB)
) scale_mul_sin (
    .ina(scale), 
    .inb(sin_angle), 
    .out(s_m_s), 
    .overflow(overflow4)
);

fxp_addsub # (
    .WIIA(8), .WIFA(8),
    .WIIB(WOIB), .WIFB(WOFB),
    .WOI(WOIB), .WOF(WOFB), .ROUND(1)
) neg_scale_mul_sin (
    .ina(16'h0000), 
    .inb(s_m_s), 
    .sub(1'b1), 
    .out(neg_s_m_s), 
    .overflow(overflow5)
);

fxp_zoom # (
    .WII(8), .WIF(8),
    .WOI(WOIB), .WOF(WOFB), .ROUND(1)
) zoom0 (
    .in(16'h0000),
    .out(zero),
    .overflow(overflow6)
);

fxp_zoom # (
    .WII(8), .WIF(8),
    .WOI(WOIB), .WOF(WOFB), .ROUND(1)
) zoom1 (
    .in(16'h0100),
    .out(one),
    .overflow(overflow7)
);

assign model_matrix[0] = s_m_c;
assign model_matrix[1] = zero;
assign model_matrix[2] = s_m_s; 
assign model_matrix[3] = x_translate;

assign model_matrix[4] = zero;
assign model_matrix[5] = scale;
assign model_matrix[6] = zero;
assign model_matrix[7] = y_translate;

assign model_matrix[8] = neg_s_m_s;
assign model_matrix[9] = zero;
assign model_matrix[10] = s_m_c;
assign model_matrix[11] = z_translate;

assign model_matrix[12] = zero;
assign model_matrix[13] = zero;
assign model_matrix[14] = zero;
assign model_matrix[15] = one;

endmodule
 */


// Eigen::Matrix4f get_model_matrix(float angle)
// {
//     Eigen::Matrix4f rotation;
//     angle = angle * MY_PI / 180.f;
//     rotation << cos(angle), 0, sin(angle), 0,
//         0, 1, 0, 0,
//         -sin(angle), 0, cos(angle), 0,
//         0, 0, 0, 1;

//     Eigen::Matrix4f scale;
//     scale << 2.5, 0, 0, 0,
//         0, 2.5, 0, 0,
//         0, 0, 2.5, 0,
//         0, 0, 0, 1;

//     Eigen::Matrix4f translate;
//     translate << 1, 0, 0, 0,
//         0, 1, 0, 0,
//         0, 0, 1, 0,
//         0, 0, 0, 1;

//     return translate * rotation * scale;
// }


/* module get_model_matrix # (
    // angle
    parameter WIIA = 4,
    parameter WIFA = 8,
    // scale, x_translate, y_translate, z_translate
    parameter WIIB = 8,
    parameter WIFB = 8,
    // output of sin, cos
    // parameter WOIA = 2,
    // parameter WOFA = 12,
    // output matrix
    parameter WOI = 8,
    parameter WOF = 8
)
(   input [WIIA+WIFA-1:0] alpha, beta, gamma,
    input [WIIB+WIFB-1:0] scale, x_translate, y_translate, z_translate,
    output logic [15:0][WOI+WOF-1:0] model_matrix
);

logic [15:0][WIIB+WIFB-1:0] S, T, R, TxR;
logic [WOI+WOF-1:0] zero, one;
logic overflow0, overflow1;


fxp_zoom # (
    .WII(8), .WIF(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) zoom0 (
    .in(16'h0000),
    .out(zero),
    .overflow(overflow0)
);

fxp_zoom # (
    .WII(8), .WIF(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) zoom1 (
    .in(16'h0100),
    .out(one),
    .overflow(overflow1)
);

assign S[0] = scale;
assign S[1] = zero;
assign S[2] = zero; 
assign S[3] = zero;
assign S[4] = zero;
assign S[5] = scale;
assign S[6] = zero;
assign S[7] = zero;
assign S[8] = zero;
assign S[9] = zero;
assign S[10] = scale;
assign S[11] = zero;
assign S[12] = zero;
assign S[13] = zero;
assign S[14] = zero;
assign S[15] = one;

assign T[0] = one;
assign T[1] = zero;
assign T[2] = zero; 
assign T[3] = x_translate;
assign T[4] = zero;
assign T[5] = one;
assign T[6] = zero;
assign T[7] = y_translate;
assign T[8] = zero;
assign T[9] = zero;
assign T[10] = one;
assign T[11] = z_translate;
assign T[12] = zero;
assign T[13] = zero;
assign T[14] = zero;
assign T[15] = one;

get_euler_angle_matrix #(.WII(WIIA), .WIF(WIFA), .WOI(WIIB), .WOF(WIFB)) euler (
    .alpha(alpha), 
    .beta(beta),
    .gamma(gamma),
    .euler_angle_matrix(R)
);

matrix_multiplier #(.WII(WIIB), .WIF(WIFB), .WOI(WIIB), .WOF(WIFB)) mm0 (
    .matA(T), .matB(R), .res_mat(TxR)
);

matrix_multiplier #(.WII(WIIB), .WIF(WIFB), .WOI(WOI), .WOF(WOF)) mm1 (
    .matA(TxR), .matB(S), .res_mat(model_matrix)
);

endmodule
 */

// precompute
// ans =
// [a1*scale, a2*scale, a3*scale, x]
// [a4*scale, a5*scale, a6*scale, y]
// [a7*scale, a8*scale, a9*scale, z]
// [       0,        0,        0, 1] 

module get_model_matrix # (
    // angle
    parameter WIIA = 4,
    parameter WIFA = 8,
    // scale, x_translate, y_translate, z_translate
    parameter WIIB = 8,
    parameter WIFB = 8,
    // output of sin, cos
    parameter WOIA = 2,
    parameter WOFA = 12,
    // output matrix
    parameter WOI = 8,
    parameter WOF = 8
)
(   input [WIIA+WIFA-1:0] alpha, beta, gamma,
    input [WIIB+WIFB-1:0] scale, x_translate, y_translate, z_translate,
    output logic [15:0][WOI+WOF-1:0] model_matrix
);

logic [WOI+WOF-1:0] zero, one;
logic [15:0][WOIA+WOFA-1:0] R;
logic [WOI+WOF-1:0] index0, index1, index2, index4, index5, index6, index8, index9, index10;
logic o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10;

fxp_zoom # (
    .WII(8), .WIF(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) zoom0 (
    .in(16'h0000),
    .out(zero),
    .overflow(o0)
);

fxp_zoom # (
    .WII(8), .WIF(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) zoom1 (
    .in(16'h0100),
    .out(one),
    .overflow(o1)
);

get_euler_angle_matrix #(.WII(WIIA), .WIF(WIFA), .WOI(WOIA), .WOF(WOFA)) euler (
    .alpha(alpha), 
    .beta(beta),
    .gamma(gamma),
    .euler_angle_matrix(R)
);

fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul0 (.ina(scale), .inb(R[0]), .out(index0), .overflow(o2));

fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul1 (.ina(scale), .inb(R[1]), .out(index1), .overflow(o3));

fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul2 (.ina(scale), .inb(R[2]), .out(index2), .overflow(o4));

fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul3 (.ina(scale), .inb(R[4]), .out(index4), .overflow(o5));

fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul4 (.ina(scale), .inb(R[5]), .out(index5), .overflow(o6));

fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul5 (.ina(scale), .inb(R[6]), .out(index6), .overflow(o7));

fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul6 (.ina(scale), .inb(R[8]), .out(index8), .overflow(o8));

fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul7 (.ina(scale), .inb(R[9]), .out(index9), .overflow(o9));

fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul8 (.ina(scale), .inb(R[10]), .out(index10), .overflow(o10));

assign model_matrix[0] = index0;
assign model_matrix[1] = index1;
assign model_matrix[2] = index2;
assign model_matrix[3] = x_translate;
assign model_matrix[4] = index4;
assign model_matrix[5] = index5;
assign model_matrix[6] = index6;
assign model_matrix[7] = y_translate;
assign model_matrix[8] = index8;
assign model_matrix[9] = index9;
assign model_matrix[10] = index10;
assign model_matrix[11] = z_translate;
assign model_matrix[12] = zero;
assign model_matrix[13] = zero;
assign model_matrix[14] = zero;
assign model_matrix[15] = one;

endmodule
