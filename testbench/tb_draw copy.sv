// testbench of the mvp transformation
// i.e. get_model_matrix.sv; get_view_matrix.sv; get_projection_matrix.sv

module tb_draw();

timeunit 10ns;
timeprecision 1ns;

logic [15:0][15:0] model, view, projection;
logic [15:0][15:0] out;

draw d(
	.model_matrix(model), .view_matrix(view), .projection_matrix(projection),
    .mvp(out)
);

initial begin
    # 5
    model[0] = 16'h0108;
    model[1] = 16'h0000;
    model[2] = 16'h0108;
    model[3] = 16'h0516;
    model[4] = 16'h0000;
    model[5] = 16'h0176;
    model[6] = 16'h0000;
    model[7] = 16'h0234;
    model[8] = 16'b1111111011111000;
    model[9] = 16'h0000;
    model[10] = 16'h0108;
    model[11] = 16'h0896;
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
    projection[11] = 16'h098f;
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
    $display($signed(out[0])*1.0/(1<<8));
    $display($signed(out[1])*1.0/(1<<8));
    $display($signed(out[2])*1.0/(1<<8));
    $display($signed(out[3])*1.0/(1<<8));
    $display($signed(out[4])*1.0/(1<<8));
    $display($signed(out[5])*1.0/(1<<8));
    $display($signed(out[6])*1.0/(1<<8));
    $display($signed(out[7])*1.0/(1<<8));
    $display($signed(out[8])*1.0/(1<<8));
    $display($signed(out[9])*1.0/(1<<8));
    $display($signed(out[10])*1.0/(1<<8));
    $display($signed(out[11])*1.0/(1<<8));
    $display($signed(out[12])*1.0/(1<<8));
    $display($signed(out[13])*1.0/(1<<8));
    $display($signed(out[14])*1.0/(1<<8));
    $display($signed(out[15])*1.0/(1<<8));
end

endmodule