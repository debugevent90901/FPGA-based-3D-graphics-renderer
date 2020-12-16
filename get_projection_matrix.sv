
// 3.1415926 = 00000011.00100100 = 0324
// 1.5707963 = 00000001.10010010 = 0192
// 180 * MY_PI * 0.5 = 0000000100011010.1011111001001011
//                   = 011a.be4b

module get_projection_matrix(   input [12:0] eye_fov, 
                                input [15:0] aspect_ratio, z_near, z_far,
                                output [15:0][15:0] projection_matrix
);

logic [15:0] neg_z_near, neg_z_far, distance, k, n_a_f, n_a_f_mul_k, tmp, f_m_n_m_k, f_m_n_m_k_2;
logic [11:0] eye_fov_m, pi_div_2_sub_eye_fov_m;
logic [13:0] sin_eye_fov, cos_eye_fov, tan_eye_fov;
logic [15:0] one_div_tan, t_d_a;

logic overflow, overflow0, overflow1, overflow2, overflow3, overflow4, overflow5, overflow6, overflow7;
logic overflow8, overflow9, overflow10, overflow11, overflow12, overflow13, overflow14, ooverflow15;  

fxp_addsub ads0(.ina(16'h0000), .inb(z_near), .sub(1'b1), .out(neg_z_near), .overflow(overflow0));
fxp_addsub ads1(.ina(16'h0000), .inb(z_far), .sub(1'b1), .out(neg_z_far), .overflow(overflow1));

fxp_addsub ads2(.ina(neg_z_near), .inb(neg_z_far), .sub(1'b1), .out(distance), .overflow(overflow2));
fxp_div div0(.dividend(16'h0100), .divisor(distance), .out(k), .overflow(overflow3));

fxp_add add0(.ina(neg_z_near), .inb(neg_z_far), .out(n_a_f), .overflow(overflow4));
fxp_mul mul0(.ina(n_a_f), .inb(k), .out(n_a_f_mul_k), .overflow(overflow5));

fxp_mul mul1(.ina(neg_z_far), .inb(neg_z_near), .out(tmp), .overflow(overflow6));
fxp_mul mul2(.ina(tmp), .inb(k), .out(f_m_n_m_k), .overflow(overflow7));
fxp_mul mul3(.ina(f_m_n_m_k), .inb(16'h0200), .out(f_m_n_m_k_2), .overflow(overflow8));


fxp_div #(
    .WIIA(4),   .WIFA(8),
    .WIIB(4),   .WIFB(8),
    .WOI(4),    .WOF(8),    .ROUND(1)
) div1 (
    .dividend(eye_fov), 
    .divisor(12'h200), 
    .out(eye_fov_m), 
    .overflow(overflow9)
);

fxp_addsub #(   
    .WIIA(4), .WIFA(8),
    .WIIB(4), .WIFB(8),
    .WOI(4), .WOF(8),   .ROUND(1)
) cos_to_sin (
    .ina(12'h192), 
    .inb(eye_fov_m), 
    .sub(1'b1), 
    .out(pi_div_2_sub_eye_fov_m), 
    .overflow(overflow10)
);

fxp_sin sin(.in(eye_fov_m), .out(sin_eye_fov), .i_overflow(overflow11));
fxp_sin cos(.in(pi_div_2_sub_eye_fov_m), .out(cos_eye_fov), .i_overflow(overflow12));
fxp_div #(
    .WIIA(2),   .WIFA(12),
    .WIIB(2),   .WIFB(12),
    .WOI(2),    .WOF(12),    .ROUND(1)
) div2 (
    .dividend(sin_eye_fov),
    .divisor(cos_eye_fov), 
    .out(tan_eye_fov), 
    .overflow(overflow13)
);

fxp_div #(
    .WIIA(8),   .WIFA(8),
    .WIIB(2),   .WIFB(12),
    .WOI(8),    .WOF(8),    .ROUND(1)
) div3 (
    .dividend(16'h0100), 
    .divisor(tan_eye_fov), 
    .out(one_div_tan), 
    .overflow(oveflow14)
);

fxp_div div4(.dividend(one_div_tan), .divisor(aspect_ratio), .out(t_d_a), .overflow(overflow15));

assign projection_matrix[0] = t_d_a;
assign projection_matrix[1] = 16'h0000;
assign projection_matrix[2] = 16'h0000;
assign projection_matrix[3] = 16'h0000;

assign projection_matrix[4] = 16'h0000;
assign projection_matrix[5] = one_div_tan;
assign projection_matrix[6] = 16'h0000;
assign projection_matrix[7] = 16'h0000;

assign projection_matrix[8] = 16'h0000;
assign projection_matrix[9] = 16'h0000;
assign projection_matrix[10] = n_a_f_mul_k;
assign projection_matrix[11] = f_m_n_m_k_2;

assign projection_matrix[12] = 16'h0000;
assign projection_matrix[13] = 16'h0000;
assign projection_matrix[14] = 16'h0100;
assign projection_matrix[15] = 16'h0000;

endmodule



// Eigen::Matrix4f get_projection_matrix(float eye_fov, float aspect_ratio, float zNear, float zFar)
// {
//     // TODO: Use the same projection matrix from the previous assignments
//     //computing improved version
//     Eigen::Matrix4f projection;
//     zNear = -zNear;
//     zFar = -zFar;
//     float inv_tan = 1 / tan(eye_fov / 180 * MY_PI * 0.5);
//     float k = 1 / (zNear - zFar);
//     projection << inv_tan / aspect_ratio, 0, 0, 0,
//         0, inv_tan, 0, 0,
//         0, 0, (zNear + zFar) * k, 2 * zFar * zNear * k,
//         0, 0, 1, 0;
//     return projection;
// }

