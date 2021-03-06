// [ scale*cos(angle),     0, scale*sin(angle), x]
// [                0, scale,                0, y]
// [-scale*sin(angle),     0, scale*cos(angle), z]
// [                0,     0,                0, 1]

// 3.1415926 = 00000011.00100100 = 0324
// 1.5707963 = 1.921fb4d12d84a

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
    parameter WOIB = 8,
    parameter WOFB = 8
)
(   input [WIIA+WIFA-1:0] angle,
    input [WIIB+WIFB-1:0] scale, x_translate, y_translate, z_translate,
    output logic [15:0][WOIB+WOFB-1:0] model_matrix
);

// logic [WIIA+WIFA-1:0] pi_div_2_sub_angle;
logic [WOIA+WOFA-1:0] sin_angle, cos_angle; 
logic [WOIB+WOFB-1:0] s_m_c, s_m_s, neg_s_m_s;
logic overflow3, overflow4, overflow5, overflow6, overflow7;
logic [WOIB+WOFB-1:0] zero, one;

cal_sin # (.WII(WIIA), .WIF(WIFA), .WOI(WOIA), .WOF(WOFA), .ROUND(1)) sin (
    .in(angle),
    .out(sin_angle)
);

cal_cos # (.WII(WIIA), .WIF(WIFA), .WOI(WOIA), .WOF(WOFA), .ROUND(1)) cos (
    .in(angle),
    .out(cos_angle)
);
//  fxp_addsub #(   
//      .WIIA(4), .WIFA(8),
//      .WIIB(WIIA), .WIFB(WIFA),
//      .WOI(WIIA), .WOF(WIFA), .ROUND(1)
//  ) cos_to_sin (
//      .ina(12'h192), 
//      .inb(angle), 
//      .sub(1'b1), 
//      .out(pi_div_2_sub_angle), 
//      .overflow(overflow0)
//  );

//  fxp_sin #(
//      .WII(WIIA),
//      .WIF(WIFA),
//      .WOI(WOIA),
//      .WOF(WOFA),
//      .ROUND(1)
//  ) sin ( 
//      .in(angle), 
//      .out(sin_angle), 
//      .i_overflow(overflow1)
//  );
//  fxp_sin # (
//      .WII(WIIA),
//      .WIF(WIFA),
//      .WOI(WOIA),
//      .WOF(WOFA),
//      .ROUND(1)
//  ) cos (
//      .in(pi_div_2_sub_angle), 
//      .out(cos_angle), 
//      .i_overflow(overflow2)
//  );

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
