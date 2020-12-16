module get_view_matrix( input [16:0] x_pos, y_pos, z_pos,
                        output logic [15:0][15:0] view_matrix
);

logic overflow0, overflow1, overflow2;
logic [15:0] neg_x_pos, neg_y_pos, neg_z_pos;

fxp_addsub ads0(.ina(16'h0000), .inb(x_pos), .sub(1'b1), .out(neg_x_pos), .overflow(overflow0));
fxp_addsub ads1(.ina(16'h0000), .inb(y_pos), .sub(1'b1), .out(neg_y_pos), .overflow(overflow1));
fxp_addsub ads2(.ina(16'h0000), .inb(z_pos), .sub(1'b1), .out(neg_z_pos), .overflow(overflow2));

assign view_matrix[0] = 16'b0001;
assign view_matrix[1] = 16'h0000;
assign view_matrix[2] = 16'h0000;
assign view_matrix[3] = neg_x_pos;

assign view_matrix[4] = 16'h0000;
assign view_matrix[5] = 16'h0001;
assign view_matrix[6] = 16'h0000;
assign view_matrix[7] = neg_y_pos;

assign view_matrix[8] = 16'h0000;
assign view_matrix[9] = 16'h0000;
assign view_matrix[10] = 16'h0001;
assign view_matrix[11] = neg_z_pos;

assign view_matrix[12] = 16'h0000;
assign view_matrix[13] = 16'h0000;
assign view_matrix[14] = 16'h0000;
assign view_matrix[15] = 16'h0001;

endmodule





// Eigen::Matrix4f get_view_matrix(Eigen::Vector3f eye_pos)
// {
//     Eigen::Matrix4f view = Eigen::Matrix4f::Identity();

//     Eigen::Matrix4f translate;
//     translate << 1, 0, 0, -eye_pos[0],
//         0, 1, 0, -eye_pos[1],
//         0, 0, 1, -eye_pos[2],
//         0, 0, 0, 1;

//     view = translate * view;

//     return view;
// }
