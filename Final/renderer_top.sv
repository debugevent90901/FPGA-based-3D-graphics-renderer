module renderer_top(
                input               CLOCK_50,
                input        [3:0]  KEY,
                input        [7:0]  SW,
                output logic [7:0]  LEDR,
                // VGA Interface
                output logic [7:0]  VGA_R,        //VGA Red
                                    VGA_G,        //VGA Green
                                    VGA_B,        //VGA Blue
                output logic        VGA_CLK,      //VGA Clock
                                    VGA_SYNC_N,   //VGA Sync signal
                                    VGA_BLANK_N,  //VGA Blank signal
                                    VGA_VS,       //VGA virtical sync signal
                                    VGA_HS        //VGA horizontal sync signal
);

    parameter WIIA = 4;
    parameter WIFA = 8;
    parameter WI = 8;
    parameter WF = 8;

    logic Reset, Clk;
    logic frame_clk;
    logic frame_clk_rising_edge;
    logic load_obj, load_done;
    logic draw_start, draw_done, proj_start, proj_done, clear_start, clear_done, frame_done;
    logic draw_data, read_data;
    logic fifo_r, fifo_w, list_r, list_w;
    logic fifo_empty, fifo_full, list_empty, list_full, list_read_done;
    logic [9:0] draw_DrawX, draw_DrawY, clear_DrawX, clear_DrawY;
    logic [9:0] DrawX, DrawY;
    logic [9:0] ReadX, ReadY;
    logic [2:0][1:0][9:0] proj_triangle_out, proj_triangle_in;
    logic [2:0][2:0][(WI+WF)-1:0] orig_triangle_in, orig_triangle_out;

    logic [WIIA+WIFA-1:0] angle;
    logic [WI+WF-1:0]     x_pos, y_pos, z_pos;


    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset <= ~(KEY[0]);        // The push buttons are active low
    end

    assign frame_clk = VGA_VS;
    assign LEDR = SW;

    //assign angle = 12'h086;

    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

    VGA_controller vga_controller_instance(
                                            .Clk(Clk),
                                            .Reset(Reset),
                                            .VGA_HS(VGA_HS),
                                            .VGA_VS(VGA_VS),
                                            .VGA_CLK(VGA_CLK),
                                            .VGA_BLANK_N(VGA_BLANK_N),
                                            .VGA_SYNC_N(VGA_SYNC_N),
                                            .ReadX(ReadX),
                                            .ReadY(ReadY)
    );

    color_mapper color_instance(
                                .is_pixel(read_data),
                                .ReadX(ReadX),
                                .ReadY(ReadY),
                                .VGA_R(VGA_R),
                                .VGA_G(VGA_G),
                                .VGA_B(VGA_B)
    );
    
    display #(.WI(WI), .WF(WF)) play(
                    .Clk(Clk),
                    .Reset(Reset),
                    .keycode(SW),
                    .frame_clk_rising_edge(frame_clk_rising_edge),
                    .theta(angle),
                    .x(x_pos),
                    .y(y_pos),
                    .z(z_pos)
    );

    control_unit cu(
                    .Clk(Clk),
                    .Reset(Reset),
                    .frame_clk(frame_clk),
                    .draw_done(draw_done),
                    .clear_done(clear_done),
                    .load_done(load_done),
                    .draw_DrawX(draw_DrawX),
                    .draw_DrawY(draw_DrawY),
                    .clear_DrawX(clear_DrawX),
                    .clear_DrawY(clear_DrawY),
                    .load_obj(load_obj),
                    .draw_start(draw_start),
                    .clear_start(clear_start),
                    .proj_start(proj_start),
                    .draw_data(draw_data),
                    .DrawX(DrawX),
                    .DrawY(DrawY),
                    .frame_clk_rising_edge(frame_clk_rising_edge),
                    .frame_done(frame_done)
    );

    clear_frame cf(
                    .Clk(Clk),
                    .Reset(Reset),
                    .clear_frame_start(clear_start),
                    .DrawX(clear_DrawX),
                    .DrawY(clear_DrawY),
                    .clear_frame_done(clear_done)
    );

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

    project #(.WIIA(WIIA), .WIFA(WIFA), .WI(WI), .WF(WF)) project_instance(
                                                                    .Clk(Clk),
                                                                    .Reset(Reset),
                                                                    .proj_start(proj_start),
                                                                    .orig_triangle(orig_triangle_out),
                                                                    .angle(angle),
                                                                    .x_translate(x_pos),
                                                                    .y_translate(y_pos),
                                                                    .z_translate(z_pos),
                                                                    .list_read_done(list_read_done),
                                                                    .proj_triangle(proj_triangle_in),
                                                                    .list_r(list_r),
                                                                    .fifo_w(fifo_w),
                                                                    .proj_done(proj_done)
    );

    triangle_fifo #(.Waddr(7), .size(100)) tf(
                                    .Clk(Clk),
                                    .Reset(Reset),
                                    .r_en(fifo_r),
                                    .w_en(fifo_w),
                                    .triangle_in(proj_triangle_in),
                                    .triangle_out(proj_triangle_out),
                                    .is_empty(fifo_empty),
                                    .is_full(fifo_full)
    );

    // fifo_writer fw(
    //                 .Clk(Clk),
    //                 .Reset(Reset),
    //                 .clear_start(clear_start),
    //                 .fifo_w(fifo_w),
    //                 .proj_triangle_in(proj_triangle_in)
    // );

    triangle_list #(.WI(WI), .WF(WF), .Waddr(7), .size(100)) tl(
                                                                .Clk(Clk),
                                                                .Reset(Reset),
                                                                .r_en(list_r),
                                                                .w_en(list_w),
                                                                .triangle_in(orig_triangle_in),
                                                                .triangle_out(orig_triangle_out),
                                                                .is_empty(list_empty),
                                                                .is_full(list_full),
                                                                .read_done(list_read_done)
    );

    list_writer #(.WI(WI), .WF(WF)) lw(
                                        .Clk(Clk),
                                        .Reset(Reset),
                                        .load_obj(load_obj),
                                        .list_w(list_w),
                                        .load_done(load_done),
                                        .orig_triangle_in(orig_triangle_in)
    );

    frame_buffer fb(
                    .Clk(Clk),
                    .Reset(Reset),
                    .frame_clk_rising_edge(frame_clk_rising_edge),
                    .DrawX(DrawX),
                    .DrawY(DrawY),
                    .draw_data(draw_data),
                    .frame_done(frame_done),
                    .ReadX(ReadX),
                    .ReadY(ReadY),
                    .read_data(read_data)
    );

endmodule
