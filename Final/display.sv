module  display #(
                    parameter WI = 8,
                    parameter WF = 8
)
(                   input                    Clk, Reset, frame_clk_rising_edge,
                    input        [7:0]       keycode,
                    // fixed-point number 4+8=12-bit
                    output logic [11:0]      theta,
                    output logic [WI+WF-1:0] x, y, z
);

    parameter [WI+WF-1:0] x_step = {{(WI){1'b0}},4'h1,{(WF-4){1'b0}}};
    parameter [WI+WF-1:0] y_step = {{(WI){1'b0}},4'h1,{(WF-4){1'b0}}};
    parameter [WI+WF-1:0] z_step = {{(WI){1'b0}},4'h1,{(WF-4){1'b0}}};

    logic [WI+WF-1:0] x_pos, y_pos, z_pos, x_pos_in, y_pos_in, z_pos_in;
    logic [11:0] angle, angle_in;
    
    assign x = x_pos;
    assign y = y_pos;
    assign z = z_pos;

    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            angle <= 12'h00a;
            x_pos <= 0;
            y_pos <= 0;
            z_pos <= 0;
        end
        else
        begin
            angle <= angle_in;
            x_pos <= x_pos_in;
            y_pos <= y_pos_in;
            z_pos <= z_pos_in;
        end
    end

    // 2*pi = 6.2831852 = 6.487ed344b6128
    always_comb
    begin
        // By default, keep motion and position unchanged
        angle_in = angle;
        x_pos_in = x_pos;
        y_pos_in = y_pos;
        z_pos_in = z_pos;

        // Update angle only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            //if ( angle+12'h00a > 12'h192 )
            if ( angle+12'h00a > 12'h648 )
                angle_in = 12'h00a;
            else
                // angle += 0.1 = 01a
                angle_in = angle + 12'h00a;
            if (keycode[0])
                x_pos_in = x_pos + x_step;
            else if (keycode[1])
                x_pos_in = x_pos - x_step;
            if (keycode[2])
                y_pos_in = y_pos + y_step;
            else if (keycode[3])
                y_pos_in = y_pos - y_step;
            if (keycode[4])
                z_pos_in = z_pos + z_step;
            else if (keycode[5])
                z_pos_in = z_pos - z_step;
        end
    end
    
    // assign output signal
    assign theta = angle;
    
endmodule
