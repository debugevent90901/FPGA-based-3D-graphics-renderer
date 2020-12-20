module project_cal_testbench();

timeunit 10ns;
timeprecision 1ns;

parameter WI = 8;
parameter WF = 8;
parameter WIIA = 4;
parameter WIFA = 8;

logic Clk;
logic [2:0][2:0][WI+WF-1:0]  orig_triangle;
logic [WIIA+WIFA-1:0]        angle;
logic [2:0][1:0][9:0] 		proj_triangle;
logic [2:0][WI+WF-1:0]      P1, P2, P3, P4, P5, P6, P7, P8;
logic [15:0][WIIA+WIFA-1:0]   mvp;
logic [15:0][WII+WIF-1:0] model_matrix, view_matrix, projection_matrix;

project_cal#(.WIIA(WIIA), .WIFA(WIFA), .WI(WI), .WF(WF)) pc (
                                                                .orig_triangle(orig_triangle),
                                                                .angle(angle),
                                                                .proj_triangle(proj_triangle)
);

assign mvp = pc.proj.mvp;
assign model_matrix = pc.mvp.model_matrix;
assign view_matrix = pc.mvp.view_matrix;
assign projection_matrix = pc.mvp.projection_matrix;
assign angle = 0;
assign P1 = 60'h000000000000;
assign P2 = 60'h000000000100;
assign P3 = 60'h000001000000;
assign P4 = 60'h000001000100;
assign P5 = 60'h010000000000;
assign P6 = 60'h010000000100;
assign P7 = 60'h010001000000;
assign P8 = 60'h010001000100;

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS

#2

#2 orig_triangle = {P1, P2, P3};

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