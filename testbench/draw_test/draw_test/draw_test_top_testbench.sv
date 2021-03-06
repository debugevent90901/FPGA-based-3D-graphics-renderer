module draw_test_top_testbench();

timeunit 10ns;
timeprecision 1ns;

logic        Clk;
logic [3:0]  KEY;

logic draw_start, draw_done, clear_start;
logic [1:0] curr_state;
logic [9:0] DrawX, DrawY;

draw_test_top dtt(.*, .CLOCK_50(Clk));

assign draw_done = dtt.draw_done;
assign DrawX = dtt.draw_DrawX;
assign DrawY = dtt.draw_DrawY;
assign curr_state = dtt.draw_instance.curr_state;

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS
KEY[0] = 0;
clear_start = 1'b0;
draw_start = 1'b0;
#50 KEY[0] = 1;
clear_start = 1'b1;
#100 clear_start = 1'b0;
draw_start = 1'b1;
#100 draw_start = 1'b0;

#600 clear_start = 1'b1;
#100 clear_start = 1'b0;
draw_start = 1'b1;
#100 draw_start = 1'b0;
end

endmodule
