module draw(input Clk, Reset,
            input draw_start,
            input [2:0][1:0][9:0] triangle_data,
            input fifo_empty,
            output logic fifo_r,
            output logic [9:0] DrawX, DrawY,
            output logic draw_done
);

    logic draw_triangle_start, draw_triangle_done;
    logic [1:0][9:0] V1, V2, V3, new_V1, new_V2, new_V3;

    enum logic [2:0] {Wait, Take1, Take2, Draw, Done} curr_state, next_state;

    draw_triangle dl(
                        .Clk(Clk),
                        .Reset(Reset),
                        .draw_triangle_start(draw_triangle_start),
                        .V1(V1),
                        .V2(V2),
                        .V3(V3),
                        .DrawX(DrawX),
                        .DrawY(DrawY),
                        .draw_triangle_done(draw_triangle_done)
    );

    always_ff @(posedge Clk)
    begin
        if (Reset)
        begin
            curr_state <= Done;
            V1 <= 0;
            V2 <= 0;
            V3 <= 0;
        end
        else
        begin
            curr_state <= next_state;
            V1 <= new_V1;
            V2 <= new_V2;
            V3 <= new_V3;
        end
    end

    always_comb
    begin
        next_state = curr_state;
        draw_triangle_start = 1'b0;
        draw_done = 1'b0;
        fifo_r = 1'b0;
        new_V1 = V1;
        new_V2 = V2;
        new_V3 = V3;
        
        unique case (curr_state)
        Wait:
        begin
            if(draw_start)
                next_state = Take1;
        end
        Take1:
        begin
            if(fifo_empty)
                next_state = Done;
            else
                next_state = Take2;
        end
        Take2:
        begin
            next_state = Draw;
        end
        Draw:
        begin
            if(draw_triangle_done)
                next_state = Take1;
        end
        Done:
        begin
            next_state = Wait;
        end
        endcase

        case (curr_state)
        Wait:
        begin
        end
        Take1:
        begin
            fifo_r = 1'b1;
            new_V1 = triangle_data[0];
            new_V2 = triangle_data[1];
            new_V3 = triangle_data[2];
        end
        Take2:
        begin
            new_V1 = triangle_data[0];
            new_V2 = triangle_data[1];
            new_V3 = triangle_data[2];
        end
        Draw:
        begin
            draw_triangle_start = 1'b1;
        end
        Done:
        begin
            draw_done = 1'b1;
        end
        endcase
    end

endmodule