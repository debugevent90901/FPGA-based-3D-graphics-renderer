module  display #(
                    parameter WI = 8,
                    parameter WF = 8
)
(                   input                    Clk, Reset, frame_clk_rising_edge,
                    input        [7:0]       keycode,
                    // fixed-point number 4+8=12-bit
                    output logic [11:0]      alpha, beta, gamma,
                    output logic [WI+WF-1:0] x, y, z
);

    parameter [WI+WF-1:0] x_step = {{(WI){1'b0}},4'h2,{(WF-4){1'b0}}};
    parameter [WI+WF-1:0] y_step = {{(WI){1'b0}},4'h2,{(WF-4){1'b0}}};
    parameter [WI+WF-1:0] z_step = {{(WI){1'b0}},4'h2,{(WF-4){1'b0}}};
    parameter [11:0]      angle_v_max = 12'h010;
    parameter [11:0]      angle_friction = 12'h002;
    parameter [11:0]      angle_a = 12'h004;

    logic [WI+WF-1:0] x_pos, y_pos, z_pos, x_pos_in, y_pos_in, z_pos_in;
    logic [11:0] x_angle, x_angle_in, x_angle_v, x_angle_v_in, x_angle_a, x_angle_a_in;
    logic [11:0] y_angle, y_angle_in, y_angle_v, y_angle_v_in, y_angle_a, y_angle_a_in;
    logic [11:0] z_angle, z_angle_in, z_angle_v, z_angle_v_in, z_angle_a, z_angle_a_in;
    
    // assign output signal
    assign x = x_pos;
    assign y = y_pos;
    assign z = z_pos;
    assign alpha = x_angle;
    assign beta = y_angle;
    assign gamma = z_angle;

    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            x_angle <= 12'h000;
            y_angle <= 12'h000;
            z_angle <= 12'h000;
            // x_angle_v <= 0;
            // y_angle_v <= 0;
            // z_angle_v <= 0;
            // x_angle_a <= 0;
            // y_angle_a <= 0;
            // z_angle_a <= 0;
            x_pos <= 0;
            y_pos <= 0;
            z_pos <= {{(WI-4){1'b1}},4'hc,{(WF){1'b0}}};
        end
        else
        begin
            // x_angle <= x_angle_in;
            // y_angle <= y_angle_in;
            // z_angle <= z_angle_in;
            // x_angle_v <= x_angle_v_in;
            // y_angle_v <= y_angle_v_in;
            // z_angle_v <= z_angle_v_in;
            // x_angle_a <= x_angle_a_in;
            // y_angle_a <= y_angle_a_in;
            // z_angle_a <= z_angle_a_in;
            x_pos <= x_pos_in;
            y_pos <= y_pos_in;
            z_pos <= z_pos_in;
        end
    end

    // 2*pi = 6.2831852 = 6.487ed344b6128
    always_comb
    begin
        // By default, keep motion and position unchanged
        // x_angle_in = x_angle;
        // y_angle_in = y_angle;
        // z_angle_in = z_angle;
        // x_angle_v_in = x_angle_v;
        // y_angle_v_in = y_angle_v;
        // z_angle_v_in = z_angle_v;
        // x_angle_a_in = 0;
        // y_angle_a_in = 0;
        // z_angle_a_in = 0;
        x_pos_in = x_pos;
        y_pos_in = y_pos;
        z_pos_in = z_pos;

        // Update angle only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // //if ( angle+12'h00a > 12'h192 )
            // if ( angle+12'h00a > 12'h648 )
            //     angle_in = 12'h00a;
            // else
            //     // angle += 0.1 = 01a
            //     angle_in = angle + 12'h00a;
            // if (keycode[0])
            //     x_pos_in = x_pos + x_step;
            // else if (keycode[1])
            //     x_pos_in = x_pos - x_step;
            // if (keycode[2])
            //     y_pos_in = y_pos + y_step;
            // else if (keycode[3])
            //     y_pos_in = y_pos - y_step;
            // if (keycode[4])
            //     z_pos_in = z_pos + z_step;
            // else if (keycode[5])
            //     z_pos_in = z_pos - z_step;

            // x-axis angle logic
            // if ( x_angle + x_angle_v > 12'h648 )
            //     x_angle_in = x_angle + x_angle_v - 12'h648;
            // else if ( $signed(x_angle + x_angle_v) < 0)
            //     x_angle_in = x_angle + x_angle_v + 12'h648;
            // else
            //     x_angle_in = x_angle + x_angle_v;
            
            // if ( x_angle_v + x_angle_a > angle_v_max )
            //     x_angle_v_in = angle_v_max;
            // else if ($signed(x_angle_v + angle_v_max) < $signed(x_angle_a))
            //     x_angle_v_in = -angle_v_max;
            // else if (x_angle_v < angle_friction && $signed(x_angle_v) > $signed(-angle_friction))
            //     x_angle_v_in = 0;
            // else
            //     x_angle_v_in = ($signed(x_angle_v) > 0) ? (x_angle_v + x_angle_a - angle_friction) : (x_angle_v + x_angle_a + angle_friction);

            // // y-axis-angle logic
            // if ( y_angle + y_angle_v > 12'h648 )
            //     y_angle_in = y_angle + y_angle_v - 12'h648;
            // else if ( $signed(y_angle + y_angle_v) < 0)
            //     y_angle_in = y_angle + y_angle_v + 12'h648;
            // else
            //     y_angle_in = y_angle + y_angle_v;
            
            // if ( y_angle_v + y_angle_a > angle_v_max )
            //     y_angle_v_in = angle_v_max;
            // else if ($signed(y_angle_v + angle_v_max) < $signed(y_angle_a))
            //     y_angle_v_in = -angle_v_max;
            // else if (y_angle_v < angle_friction && $signed(y_angle_v) > $signed(-angle_friction))
            //     y_angle_v_in = 0;
            // else
            //     y_angle_v_in = ($signed(y_angle_v) > 0) ? (y_angle_v + y_angle_a - angle_friction) : (y_angle_v + y_angle_a + angle_friction);

            // // z-axis-angle logic
            // if ( z_angle + z_angle_v > 12'h648 )
            //     z_angle_in = z_angle + z_angle_v - 12'h648;
            // else if ( $signed(z_angle + z_angle_v) < 0)
            //     z_angle_in = z_angle + z_angle_v + 12'h648;
            // else
            //     z_angle_in = z_angle + z_angle_v;
            
            // if ( z_angle_v + z_angle_a > angle_v_max )
            //     z_angle_v_in = angle_v_max;
            // else if ($signed(z_angle_v + angle_v_max) < $signed(z_angle_a))
            //     z_angle_v_in = -angle_v_max;
            // else if (z_angle_v < angle_friction && $signed(z_angle_v) > $signed(-angle_friction))
            //     z_angle_v_in = 0;
            // else
            //     z_angle_v_in = ($signed(z_angle_v) > 0) ? (z_angle_v + z_angle_a - angle_friction) : (z_angle_v + z_angle_a + angle_friction);

            unique case(keycode)
            // // w
            // 8'h1A:
            // begin
            //     y_angle_a_in = angle_a;
            // end
            // // s
            // 8'h16:
            // begin
            //     y_angle_a_in = -angle_a;
            // end
            // // a
            // 8'h04:
            // begin
            //     z_angle_a_in = angle_a;
            // end
            // // d
            // 8'h07:
            // begin
            //     z_angle_a_in = -angle_a;
            // end
            // // q
            // 8'h14:
            // begin
            //     x_angle_a_in = angle_a;
            // end
            // // e
            // 8'h08:
            // begin
            //     x_angle_a_in = -angle_a;
            // end
            // up
            8'h52:
            begin
                z_pos_in = z_pos + z_step;
            end
            // down
            8'h51:
            begin
                z_pos_in = z_pos - z_step;
            end
            // left
            8'h50:
            begin
                x_pos_in = x_pos - x_step;
            end
            // right
            8'h4f:
            begin
                x_pos_in = x_pos + x_step;
            end
            // z
            8'h1d:
            begin
                y_pos_in = y_pos + y_step;
            end
            // x
            8'h1b:
            begin
                y_pos_in = y_pos - y_step;
            end
            default:
            begin
            end
            endcase
        end
    end
    
endmodule
