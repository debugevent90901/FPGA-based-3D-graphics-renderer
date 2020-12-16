// testbench of the mvp transformation
// i.e. get_model_matrix.sv; get_view_matrix.sv; get_projection_matrix.sv

module tb_projection_matrix();

timeunit 10ns;
timeprecision 1ns;

logic [12:0]        eye_fov;
logic [15:0]        aspect_ratio, z_near, z_far;

logic [15:0][15:0]  out;

// test get_model_matrix.sv
get_projection_matrix gmm(
    .eye_fov            ( eye_fov       ),
    .aspect_ratio       ( aspect_ratio  ),
    .z_near             ( z_near        ),
    .z_far              ( z_far         ),
    .projection_matrix  ( out           )
);


// eye_fov = pi/3 = 1.04719753 = 1.0c152327cd4e8
// aspect_ratio = 1.6789 = 1.adcc63f141206
// z_near, z_far = 2.203125, 4.0859375 = 2.34, 4.16

// The answer is supposed to be:
// [[ 1.03165814  0.          0.          0.        ]
//  [ 0.          1.73205085  0.          0.        ]
//  [ 0.          0.         -3.34024896  9.562111  ]
//  [ 0.          0.          1.          0.        ]]


initial begin
    # 5
    eye_fov = 12'h10c;
    # 5
    aspect_ratio = 16'h01ad;
    # 5
    z_near = 16'h0234;
    # 5
    z_far = 16'h0416;

    $display("eye_fov");
    $display($signed(eye_fov)*1.0/(1<<8));
    $display("aspect_ratio");
    $display($signed(aspect_ratio)*1.0/(1<<8));
    $display("z_near");
    $display($signed(z_near)*1.0/(1<<8));
    $display("z_far");
	$display($signed(z_far)*1.0/(1<<8));
    # 10
    $display("projection_matrix");
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
