module renderer_top_testbench();

timeunit 10ns;
timeprecision 1ns;

logic        Clk;
logic [3:0]  KEY;
                            // VGA Interface 
logic [7:0]  VGA_R;         //VGA Red
logic [7:0]  VGA_G;         //VGA Green
logic [7:0]  VGA_B;         //VGA Blue
logic        VGA_CLK;       //VGA Clock
logic        VGA_SYNC_N;    //VGA Sync signal
logic        VGA_BLANK_N;   //VGA Blank signal
logic        VGA_VS;        //VGA virtical sync signal
logic        VGA_HS;         //VGA horizontal sync signal

logic draw_start, draw_done, clear_start, clear_done;
logic draw_data, read_data;
logic [9:0] DrawX, DrawY;
logic [9:0] ReadX, ReadY;

renderer_top rt(.*, .CLOCK_50(Clk));

assign draw_start = rt.draw_start;
assign draw_done = rt.draw_done;
assign clear_start = rt.clear_start;
assign clear_done = rt.clear_done;
assign draw_data = rt.draw_data;
assign read_data = rt.read_data;
assign DrawX = rt.DrawX;
assign DrawY = rt.DrawY;
assign ReadX = rt.ReadX;
assign ReadY = rt.ReadY;
assign curr_state = rt.cu.curr_state;

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS
KEY[0] = 0;
#120 KEY[0] = 1;

#100;
end

endmodule
