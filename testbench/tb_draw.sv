// testbench of the mvp transformation
// i.e. get_model_matrix.sv; get_view_matrix.sv; get_projection_matrix.sv

module tb_draw();

timeunit 10ns;
timeprecision 1ns;

logic [3:0][15:0] a, b, c;
logic [15:0][15:0] mvp;
logic [8:0] w, h;

logic [1:0][9:0] v1, v2, v3;

draw d(
        .vertex_a(a), .vertex_b(b), .vertex_c(c),
        .mvp(mvp),
        .height(h), .width(w),
        .V1(v1), .V2(v2), .V3(v3)
);

initial begin
    # 5
    w = 8'h1e;
    h = 8'h28;
    # 5
    mvp[0] = 16'h0111;
    mvp[1] = 16'h0000;
    mvp[2] = 16'h0111;
    mvp[3] = 16'h02f9;
    mvp[4] = 16'h0000;
    mvp[5] = 16'h0288;
    mvp[6] = 16'h0000;
    mvp[7] = 16'b1111110010111110;
    mvp[8] = 16'h0373;
    mvp[9] = 16'h0000;
    mvp[10] = 16'b1111110010001101;
    mvp[11] = 16'b1111100011011101;
    mvp[12] = 16'b1111111011111000;
    mvp[13] = 16'h0000;
    mvp[14] = 16'h0108;
    mvp[15] = 16'h0500;

    #5
    a[0] = 16'h031a;
    a[1] = 16'h0000;
    a[2] = 16'h0000;
    a[3] = 16'h0100;
    #5
    b[0] = 16'h0000;
    b[1] = 16'h02e6;
    b[2] = 16'h0000;
    b[3] = 16'h0100;
    #5
    c[0] = 16'h0000;
    c[1] = 16'h0000;
    c[2] = 16'h0480;
    c[3] = 16'h0100;
    #5

    $display("width");
    $display($signed(w));
    $display("height");
    $display($signed(h));

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

    # 10
    $display("V1");
    $display($signed(v1[0])*1.0/(1<<8));
    $display($signed(v1[1])*1.0/(1<<8));

    $display("V2");
    $display($signed(v2[0])*1.0/(1<<8));
    $display($signed(v2[1])*1.0/(1<<8));

    $display("V3");
    $display($signed(v3[0])*1.0/(1<<8));
    $display($signed(v3[1])*1.0/(1<<8));
end

endmodule