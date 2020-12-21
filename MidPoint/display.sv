module  display (   input                   Clk, Reset, frame_clk_rising_edge,
                    // fixed-point number 4+8=12-bit
                    output logic [11:0]     theta
);

    logic [11:0] angle, angle_in;
    
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
            angle <= 12'h001;
        else
            angle <= angle_in;
    end

    // 2*pi = 6.2831852 = 6.487ed344b6128
    always_comb
    begin
        // By default, keep motion and position unchanged
        angle_in = angle;
        
        // Update angle only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            if ( angle > 12'h192 )
                angle_in = 12'h001;
            else
                // angle += 0.1 = 01a
                angle_in = angle + 12'h00a;
        end
    end
    
    // assign output signal
    assign theta = angle;
    
endmodule
