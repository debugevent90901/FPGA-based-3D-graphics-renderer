
// 3.1415926 = 00000011.00100100 = 0324
// 1.5707963 = 00000001.10010010 = 0192
// 180 * MY_PI * 0.5 = 0000000100011010.1011111001001011
//                   = 011a.be4b

module get_projection_matrix(   input [15:0] eye_fov, aspect_ratio, z_near, z_far,
                                output [15:0][15:0] projection_matrix
);

logic [15:0] neg_z_near, neg_z_far, distance, k, n_a_f, n_a_f_mul_k, tmp, f_m_n_m_k, f_m_n_m_k_2;
logic [15:0] eye_fov_m, eye_fov_m_add_pi_div_2, sin_eye_fov, cos_eye_fov, tan_eye_fov, one_div_tan, t_d_a;

logic overflow, overflow0, overflow1, overflow2, overflow3, overflow4, overflow5, overflow6, overflow7;
logic overflow8, overflow9, overflow10, overflow11, overflow12, overflow13, overflow114514;  

fxp_addsub ads0(.ina(16'h0000), .inb(z_near), .sub(1'b1), .out(neg_z_near), .overflow(overflow0));
fxp_addsub ads1(.ina(16'h0000), .inb(z_far), .sub(1'b1), .out(neg_z_far), .overflow(overflow1));

fxp_addsub ads2(.ina(neg_z_near), .inb(neg_z_far), .sub(1'b1), .out(distance), .overflow(overflow2));
fxp_div div0(.dividend(16'h0001), .divisor(distance), .out(k), .overflow(overflow3));

fxp_add add0(.ina(neg_z_near), .inb(neg_z_far), .out(n_a_f), .overflow(overflow4));

fxp_mul mul0(.ina(n_a_f), .inb(k), .out(n_a_f_mul_k), .overflow(overflow5));
fxp_mul mul1(.ina(neg_z_near), inb(neg_z_far), .out(tmp), overflow(overflow6));
fxp_mul mul2(.ina(tmp), .inb(k), .out(f_m_n_m_k), .overflow(overflow7));
fxp_mul mul3(.ina(f_m_n_m_k), .inb(16'h0002), .out(f_m_n_m_k_2), .overflow(overflow));

fxp_div div(.dividend(eye_fov), .divisor(16'h0002), .out(eye_fov_m), .overflow(overflow114514));

fxp_add cos_to_sin(.ina(eye_fov_m), .inb(16'h0192), .out(eye_fov_m_add_pi_div_2), .overflow(overflow8));
fxp_sin sin(.in(eye_fov_m), .out(sin_eye_fov), .i_overflow(overflow9));
fxp_sin cos(.in(eye_fov_m_add_pi_div_2), .out(cos_eye_fov), .i_overflow(overflow10));
fxp_div div0(.dividend(sin_eye_fov), .divisor(cos_eye_fov), .out(tan_eye_fov), .overflow(overflow11));
fxp_div div1(.dividend(16'h0001), .divisor(tan_eye_fov), .out(one_div_tan), .overflow(oveflow12));

fxp_div div2(.dividend(tan_eye_fov), .divisor(aspect_ratio), .out(t_d_a), .overflow(overflow13));

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
assign projection_matrix[14] = 16'h0001;
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

