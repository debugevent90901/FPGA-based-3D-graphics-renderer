module tb_euler_angle();

timeunit 10ns;
timeprecision 1ns;

logic [11:0]        alpha, beta, gamma;
logic [15:0][13:0]  euler;

get_euler_angle_matrix geam(
	.alpha(alpha), .beta(beta), .gamma(gamma),
    .euler_angle_matrix(euler)
);


// pi = 3.1415926 = 3.243f69a25b094
// pi/2 = 1.921fb4d12d84a
// 1.5pi = 4.b65f1e73888dc
// 2pi=  6.487ed344b6128

initial begin
    # 5
    alpha = 12'h181;
    beta = 12'h286;
    gamma = 12'h345;
    #5
    $display($signed(alpha)*1.0/(1<<8));
    $display($signed(beta)*1.0/(1<<8));
    $display($signed(gamma)*1.0/(1<<8));
    # 10
    $display("euler_angle");
    $display($signed(euler[0])*1.0/(1<<12));
    $display($signed(euler[1])*1.0/(1<<12));
    $display($signed(euler[2])*1.0/(1<<12));
    $display($signed(euler[3])*1.0/(1<<12));
    $display($signed(euler[4])*1.0/(1<<12));
    $display($signed(euler[5])*1.0/(1<<12));
    $display($signed(euler[6])*1.0/(1<<12));
    $display($signed(euler[7])*1.0/(1<<12));
    $display($signed(euler[8])*1.0/(1<<12));
    $display($signed(euler[9])*1.0/(1<<12));
    $display($signed(euler[10])*1.0/(1<<12));
    $display($signed(euler[11])*1.0/(1<<12));
    $display($signed(euler[12])*1.0/(1<<12));
    $display($signed(euler[13])*1.0/(1<<12));
    $display($signed(euler[14])*1.0/(1<<12));
    $display($signed(euler[15])*1.0/(1<<12));
end

endmodule