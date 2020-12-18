// testbench of the mvp transformation
// i.e. get_model_matrix.sv; get_view_matrix.sv; get_projection_matrix.sv

module tb_draw();

timeunit 10ns;
timeprecision 1ns;

logic [3:0][15:0] a, b, c;
logic [15:0][15:0] model, view, projection;
logic [15:0] w, h;

logic [1:0][9:0] v1, v2, v3;

draw d(
    .vertex_a(a), .vertex_b(b), .vertex_c(c),
	 .model_matrix(model), .view_matrix(view), .projection_matrix(projection),
	 .height(h), .width(w),
	 .V1(v1), .V2(v2), .V3(v3)
);

initial begin
    # 5
    w = 16'h1e00;
    h = 16'h2800;
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
    a[0] = 16'h0380;
    a[1] = 16'h0000;
    a[2] = 16'h0000;
    a[3] = 16'h0100;
    #5
    b[0] = 16'h0000;
    b[1] = 16'h0233;
    b[2] = 16'h0000;
    b[3] = 16'h0100;
    #5
    c[0] = 16'h0000;
    c[1] = 16'h0000;
    c[2] = 16'h0566;
    c[3] = 16'h0100;
    #5

    $display("width");
    $display($signed(w)*1.0/(1<<8));
    $display("height");
    $display($signed(h)*1.0/(1<<8));
    $display("vertex_a_x");
    $display($signed(a[0])*1.0/(1<<8));
    $display("vertex_a_y");
	$display($signed(a[1])*1.0/(1<<8));
    $display("vertex_a_z");
	$display($signed(a[2])*1.0/(1<<8));

    $display("vertex_b_x");
    $display($signed(b[0])*1.0/(1<<8));
    $display("vertex_b_y");
	$display($signed(b[1])*1.0/(1<<8));
    $display("vertex_b_z");
	$display($signed(b[2])*1.0/(1<<8));

    $display("vertex_c_x");
    $display($signed(c[0])*1.0/(1<<8));
    $display("vertex_c_y");
	$display($signed(c[1])*1.0/(1<<8));
    $display("vertex_c_z");
	$display($signed(c[2])*1.0/(1<<8));

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
    $display("V1");
    $display($signed(V1[0])*1.0/(1<<8));
    $display($signed(V1[1])*1.0/(1<<8));

    $display("V2");
    $display($signed(V2[0])*1.0/(1<<8));
    $display($signed(V2[1])*1.0/(1<<8));

    $display("V3");
    $display($signed(V3[0])*1.0/(1<<8));
    $display($signed(V3[1])*1.0/(1<<8));
end

endmodule