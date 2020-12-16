// [ scale*cos(angle),     0, 0, x + scale*sin(angle)]
// [                0, scale, 0,                    y]
// [-scale*sin(angle),     0, 0, z + scale*cos(angle)]
// [                0,     0, 0,                    1]

// 3.1415926 = 00000011.00100100 = 0324
// 1.5707963 = 00000001.10010010 = 0192

module get_model_matrix(    input [15:0] angle, scale,
                            input [15:0] x_translate, y_translate, z_translate;
                            output logic [15:0][15:0] model_matrix
);



logic [15:0] angle_add_pi_div_2, sin_angle, cos_angle; s_m_c, s_m_s, x_s_m_s, z_s_m_c, neg_s_m_s;
logic overflow0, overflow1, overflow2, overflow3, overflow4, overflow5, overflow6, overflow7;

fxp_add cos_to_sin(.ina(angle), .inb(16'h0192), .out(angle_add_pi_div_2), .overflow(overflow0));
fxp_sin sin(.in(angle), .out(sin_angle), .i_overflow(overflow1));
fxp_sin cos(.in(angle_add_pi_div_2), .out(cos_angle), .i_overflow(overflow2));

fxp_mul scale_mul_cos(.ina(scale), .inb(cos_angle), .out(s_m_c), .overflow(overflow3));
fxp_mul scale_mul_sin(.ina(scale), .inb(sin_angle), .out(s_m_s), .overflow(overflow4));

fxp_add x_add_scale_mul_sin(.ina(x_translate), .inb(s_m_s), .out(), .overflow(overflow5));
fxp_add z_add_scale_mul_cos(.ina(z_translate), .inb(s_m_c), .out(), .overflow(overflow6));
fxp_addsub neg_scale_mul_sin(.ina(16'h000), .inb(s_m_s), .sub(1'b1), .out(), .overflow(overflow7));

assign view_matrix[0] = s_m_c;
assign view_matrix[1] = 16'h0000;
assign view_matrix[2] = 16'h0000;
assign view_matrix[3] = x_s_m_s;

assign view_matrix[4] = 16'h0000;
assign view_matrix[5] = scale;
assign view_matrix[6] = 16'h0000;
assign view_matrix[7] = y_translate;

assign view_matrix[8] = neg_s_m_s;
assign view_matrix[9] = 16'h0000;
assign view_matrix[10] = 16'h0001;
assign view_matrix[11] = z_s_m_c;

assign view_matrix[12] = 16'h0000;
assign view_matrix[13] = 16'h0000;
assign view_matrix[14] = 16'h0000;
assign view_matrix[15] = 16'h0001;


endmodule





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
