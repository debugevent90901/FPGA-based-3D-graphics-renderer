module tb_euler_angle();

timeunit 10ns;
timeprecision 1ns;

logic [11:0]        alpha, beta, gamma;
logic [15:0][13:0]  euler;

get_mvp_matrix gmm(
	.alpha(alpha), .beta(beta), .gamma(gamma),
    .euler_angle_matrix(euler)
);

initial begin
    # 5
    model[0] = 16'h0108;
    model[1] = 16'h0000;
    model[2] = 16'h0108;
    model[3] = 16'h0351;

    model[4] = 16'h0000;
    model[5] = 16'h0176;
    model[6] = 16'h0000;
    model[7] = 16'h0698;

    model[8] = 16'b1111111011111000;
    model[9] = 16'h0000;
    model[10] = 16'h0108;
    model[11] = 16'h013c;

    model[12] = 16'h0000;
    model[13] = 16'h0000;
    model[14] = 16'h0000;
    model[15] = 16'h0100;
    # 5
    view[0] = 16'h0100;
    view[1] = 16'h0000;
    view[2] = 16'h0000;
    view[3] = 16'b1111110111001100;

    view[4] = 16'h0000;
    view[5] = 16'h0100;
    view[6] = 16'h0000;
    view[7] = 16'b1111101111101010;

    view[8] = 16'h0000;
    view[9] = 16'h0000;
    view[10] = 16'h0100;
    view[11] = 16'b1111110001101010;

    view[12] = 16'h0000;
    view[13] = 16'h0000;
    view[14] = 16'h0000;
    view[15] = 16'h0100;
    # 5 
    projection[0] = 16'h0108;
    projection[1] = 16'h0000;
    projection[2] = 16'h0000;
    projection[3] = 16'h0000;

    projection[4] = 16'h0000;
    projection[5] = 16'h01bb;
    projection[6] = 16'h0000;
    projection[7] = 16'h0000;

    projection[8] = 16'h0000;
    projection[9] = 16'h0000;
    projection[10] = 16'b1111110010101001;
    projection[11] = 16'h0990;

    projection[12] = 16'h0000;
    projection[13] = 16'h0000;
    projection[14] = 16'h0100;
    projection[15] = 16'h0000;
    #5

    $display("model_matrix");
    $display($signed(model[0])*1.0/(1<<8));
    $display($signed(model[1])*1.0/(1<<8));
    $display($signed(model[2])*1.0/(1<<8));
    $display($signed(model[3])*1.0/(1<<8));
    $display($signed(model[4])*1.0/(1<<8));
    $display($signed(model[5])*1.0/(1<<8));
    $display($signed(model[6])*1.0/(1<<8));
    $display($signed(model[7])*1.0/(1<<8));
    $display($signed(model[8])*1.0/(1<<8));
    $display($signed(model[9])*1.0/(1<<8));
    $display($signed(model[10])*1.0/(1<<8));
    $display($signed(model[11])*1.0/(1<<8));
    $display($signed(model[12])*1.0/(1<<8));
    $display($signed(model[13])*1.0/(1<<8));
    $display($signed(model[14])*1.0/(1<<8));
    $display($signed(model[15])*1.0/(1<<8));

    $display("view_matrix");
    $display($signed(view[0])*1.0/(1<<8));
    $display($signed(view[1])*1.0/(1<<8));
    $display($signed(view[2])*1.0/(1<<8));
    $display($signed(view[3])*1.0/(1<<8));
    $display($signed(view[4])*1.0/(1<<8));
    $display($signed(view[5])*1.0/(1<<8));
    $display($signed(view[6])*1.0/(1<<8));
    $display($signed(view[7])*1.0/(1<<8));
    $display($signed(view[8])*1.0/(1<<8));
    $display($signed(view[9])*1.0/(1<<8));
    $display($signed(view[10])*1.0/(1<<8));
    $display($signed(view[11])*1.0/(1<<8));
    $display($signed(view[12])*1.0/(1<<8));
    $display($signed(view[13])*1.0/(1<<8));
    $display($signed(view[14])*1.0/(1<<8));
    $display($signed(view[15])*1.0/(1<<8));

    $display("projection_matrix");
    $display($signed(projection[0])*1.0/(1<<8));
    $display($signed(projection[1])*1.0/(1<<8));
    $display($signed(projection[2])*1.0/(1<<8));
    $display($signed(projection[3])*1.0/(1<<8));
    $display($signed(projection[4])*1.0/(1<<8));
    $display($signed(projection[5])*1.0/(1<<8));
    $display($signed(projection[6])*1.0/(1<<8));
    $display($signed(projection[7])*1.0/(1<<8));
    $display($signed(projection[8])*1.0/(1<<8));
    $display($signed(projection[9])*1.0/(1<<8));
    $display($signed(projection[10])*1.0/(1<<8));
    $display($signed(projection[11])*1.0/(1<<8));
    $display($signed(projection[12])*1.0/(1<<8));
    $display($signed(projection[13])*1.0/(1<<8));
    $display($signed(projection[14])*1.0/(1<<8));
    $display($signed(projection[15])*1.0/(1<<8));

    # 10
    $display("mvp_matrix");
    $display($signed(mvp[0])*1.0/(1<<8));
    $display($signed(mvp[1])*1.0/(1<<8));
    $display($signed(mvp[2])*1.0/(1<<8));
    $display($signed(mvp[3])*1.0/(1<<8));
    $display($signed(mvp[4])*1.0/(1<<8));
    $display($signed(mvp[5])*1.0/(1<<8));
    $display($signed(mvp[6])*1.0/(1<<8));
    $display($signed(mvp[7])*1.0/(1<<8));
    $display($signed(mvp[8])*1.0/(1<<8));
    $display($signed(mvp[9])*1.0/(1<<8));
    $display($signed(mvp[10])*1.0/(1<<8));
    $display($signed(mvp[11])*1.0/(1<<8));
    $display($signed(mvp[12])*1.0/(1<<8));
    $display($signed(mvp[13])*1.0/(1<<8));
    $display($signed(mvp[14])*1.0/(1<<8));
    $display($signed(mvp[15])*1.0/(1<<8));
end

endmodule