// testbench of the mvp transformation
// i.e. get_model_matrix.sv; get_view_matrix.sv; get_projection_matrix.sv

/* module tb_model_matrix();

timeunit 10ns;
timeprecision 1ns;

logic [15:0]        angle;
logic [15:0]        scale;
logic [15:0]        x, y, z;

logic [15:0][15:0]  out;

// test get_model_matrix.sv
get_model_matrix gmm(
    .angle          ( angle  ),
    .scale          ( scale  ),
    .x_translate    ( x      ),
    .y_translate    ( y      ),
    .z_translate    ( z      ),
    .model_matrix   ( out    )
);


// [ scale*cos(angle),     0, scale*sin(angle), x]
// [                0, scale,                0, y]
// [-scale*sin(angle),     0, scale*cos(angle), z]
// [                0,     0,                0, 1]

// angle = pi/4 = 0.78539815 = 0.c90fda6896c25
// scale = 1.4609375
// x, y, z = 2.203125, 4.0859375, 3.5859375

// The answer is supposed to be:
// [[ 1.03303883  0.          1.0330388   2.203125  ]
//  [ 0.          1.4609375   0.          4.0859375 ]
//  [-1.0330388   0.          1.03303883  3.5859375 ]
//  [ 0.          0.          0.          1.        ]]

initial begin
    # 5
    angle = 12'h0c9;
    # 5
    scale = 16'h0176;
    # 5
    x = 16'h0234;
    # 5
    y = 16'h0416;
    # 5 
    z = 16'h0396;


    $display("angle");
    $display($signed(angle)*1.0/(1<<8));
    $display("scale");
    $display($signed(scale)*1.0/(1<<8));
    $display("x_translate");
    $display($signed(x)*1.0/(1<<8));
    $display("y_translate");
	$display($signed(y)*1.0/(1<<8));
    $display("z_translate");
	$display($signed(z)*1.0/(1<<8));
    # 10
    $display("model_matrix");
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
 */


module tb_model_matrix();

timeunit 10ns;
timeprecision 1ns;

logic [11:0]        a, b, c;
logic [15:0]        scale;
logic [15:0]        x, y, z;

logic [15:0][15:0]  out;

// test get_model_matrix.sv
get_model_matrix gmm(
    .alpha          ( a      ),
    .beta           ( b      ),
    .gamma          ( c      ),
    .scale          ( scale  ),
    .x_translate    ( x      ),
    .y_translate    ( y      ),
    .z_translate    ( z      ),
    .model_matrix   ( out    )
);

// logic [15:0][13:0] R;
// assign R = gmm.R;

// alpha = 1.50390625
// beta = 2.5234375
// gamma = 3.26953125

// scale = 1.4609375
// x, y, z = 2.203125, 4.0859375, 3.5859375

// The euler matrix is supposed to be:
// [[-0.17004062 -0.98265899 -0.07394249  0.        ]
//  [-0.79795271  0.1813307  -0.57479618  0.        ]
//  [ 0.57823668 -0.03873609 -0.81494899  0.        ]
//  [ 0.          0.          0.          1.        ]]

// The final answer is supposed to be:
// [[-0.24841872 -1.43560337 -0.10802536  2.203125  ]
//  [-1.16575904  0.26491281 -0.83974129  4.0859375 ]
//  [ 0.84476765 -0.056591   -1.19058954  3.5859375 ]
//  [ 0.          0.          0.          1.        ]]

initial begin
    # 5
    a = 12'h181;
    b = 12'h286;
    c = 12'h345;
    # 5
    scale = 16'h0176;
    # 5
    x = 16'h0234;
    # 5
    y = 16'h0416;
    # 5 
    z = 16'h0396;

    # 20
    $display("alpha");
    $display($signed(a)*1.0/(1<<8));
    $display("beta");
    $display($signed(b)*1.0/(1<<8));
    $display("gamma");
    $display($signed(c)*1.0/(1<<8));
    $display("scale");
    $display($signed(scale)*1.0/(1<<8));
    $display("x_translate");
    $display($signed(x)*1.0/(1<<8));
    $display("y_translate");
	$display($signed(y)*1.0/(1<<8));
    $display("z_translate");
	$display($signed(z)*1.0/(1<<8));

    $display("model_matrix");
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
