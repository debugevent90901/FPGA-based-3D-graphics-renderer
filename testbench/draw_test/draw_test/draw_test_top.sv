module draw_test_top(
                input               CLOCK_50,
                input        [3:0]  KEY,
                input               draw_start,
                input               clear_start
);

    logic Reset, Clk;
    logic draw_done;
    logic fifo_r, fifo_w;
    logic fifo_empty, fifo_full;
    logic [9:0] draw_DrawX, draw_DrawY;
    logic [2:0][1:0][9:0] proj_triangle_out, proj_triangle_in;

    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset <= ~(KEY[0]);        // The push buttons are active low
    end

    draw draw_instance(
                        .Clk(Clk),
                        .Reset(Reset),
                        .draw_start(draw_start),
                        .triangle_data(proj_triangle_out),
                        .fifo_empty(fifo_empty),
                        .fifo_r(fifo_r),
                        .DrawX(draw_DrawX),
                        .DrawY(draw_DrawY),
                        .draw_done(draw_done)
    );

    triangle_fifo #(.size(100)) tf(
                                    .Clk(Clk),
                                    .Reset(Reset),
                                    .r_en(fifo_r),
                                    .w_en(fifo_w),
                                    .triangle_in(proj_triangle_in),
                                    .triangle_out(proj_triangle_out),
                                    .is_empty(fifo_empty),
                                    .is_full(fifo_full)
    );

    fifo_writer fw(
                    .Clk(Clk),
                    .Reset(Reset),
                    .clear_start(clear_start),
                    .fifo_w(fifo_w),
                    .proj_triangle_in(proj_triangle_in)
    );

endmodule
