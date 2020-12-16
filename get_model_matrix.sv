// [ scale*cos(angle),     0, 0, x + scale*sin(angle)]
// [                0, scale, 0,                    y]
// [-scale*sin(angle),     0, 0, z + scale*cos(angle)]
// [                0,     0, 0,                    1]

// 3.1415926 = 00000011.00100100 = 0324
// 1.5707963 = 1.921fb4d12d84a

module get_model_matrix(    input [15:0] angle, scale,
                            input [15:0] x_translate, y_translate, z_translate,
                            output logic [15:0][15:0] model_matrix
);

logic [15:0] pi_div_2_sub_angle, sin_angle, cos_angle, s_m_c, s_m_s, neg_s_m_s;
logic overflow0, overflow1, overflow2, overflow3, overflow4, overflow5;

fxp_addsub #(   
    .WIIA(4), .WIFA(8),
    .WIIB(4), .WIFB(8),
    .WOI(4), .WOF(8), .ROUND(1)
) cos_to_sin (
    .ina(12'h192), 
    .inb(angle), 
    .sub(1'b1), 
    .out(pi_div_2_sub_angle), 
    .overflow(overflow0)
);

fxp_sin sin(.in(angle), .out(sin_angle), .i_overflow(overflow1));
fxp_sin cos(.in(pi_div_2_sub_angle), .out(cos_angle), .i_overflow(overflow2));

fxp_mul #(  
    .WIIA(8),   .WIFA(8),
    .WIIB(2),   .WIFB(12),
    .WOI(8),    .WOF(8)
) scale_mul_cos (
    .ina(scale), 
    .inb(cos_angle), 
    .out(s_m_c), 
    .overflow(overflow3)
);

fxp_mul #(  
    .WIIA(8),   .WIFA(8),
    .WIIB(2),   .WIFB(12),
    .WOI(8),    .WOF(8)
) scale_mul_sin (
    .ina(scale), 
    .inb(sin_angle), 
    .out(s_m_s), 
    .overflow(overflow4)
);

fxp_addsub neg_scale_mul_sin(.ina(16'h0000), .inb(s_m_s), .sub(1'b1), .out(neg_s_m_s), .overflow(overflow5));

assign model_matrix[0] = s_m_c;
assign model_matrix[1] = 16'h0000;
assign model_matrix[2] = s_m_s; 
assign model_matrix[3] = x_translate;

assign model_matrix[4] = 16'h0000;
assign model_matrix[5] = scale;
assign model_matrix[6] = 16'h0000;
assign model_matrix[7] = y_translate;

assign model_matrix[8] = neg_s_m_s;
assign model_matrix[9] = 16'h0000;
assign model_matrix[10] = s_m_c;
assign model_matrix[11] = z_translate;

assign model_matrix[12] = 16'h0000;
assign model_matrix[13] = 16'h0000;
assign model_matrix[14] = 16'h0000;
assign model_matrix[15] = 16'h0100;

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
