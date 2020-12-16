// testbench of the mvp transformation
// i.e. get_model_matrix.sv; get_view_matrix.sv; get_projection_matrix.sv

module tb_view_matrix();

timeunit 10ns;
timeprecision 1ns;

logic [15:0]        inx;
logic [15:0]        iny;
logic [15:0]        inz;
logic [15:0][15:0]  out;

// test get_view_matrix.sv
get_view_matrix mat_mul(
    .x_pos      ( inx      ),
    .y_pos      ( iny      ),
    .z_pos      ( inz      ),
    .view_matrix( out      )
);


// x1, y1, z1 = 2.203125, 4.0859375, 3.5859375

// The answer is supposed to be:
// [[ 1.         0.         0.        -2.203125 ]
//  [ 0.         1.         0.        -4.0859375]
//  [ 0.         0.         1.        -3.5859375]
//  [ 0.         0.         0.         1.       ]]

initial begin
    # 5
    inx = 16'h0234;
    # 5
    iny = 16'h0416;
    # 5 
    inz = 16'h0396;

    $display($signed(inx)*1.0/(1<<8));
	$display($signed(iny)*1.0/(1<<8));
	$display($signed(inz)*1.0/(1<<8));
    # 10
    $display("view_matrix");
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
