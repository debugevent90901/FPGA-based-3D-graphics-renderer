module project #(
                parameter WIIA = 4,
                parameter WIFA = 8,
                parameter WI = 8,
                parameter WF = 8
)
( 
                input                        Clk, Reset,
                input                        proj_start,
                input [2:0][2:0][WI+WF-1:0]  orig_triangle,
                input [WIIA+WIFA-1:0]        angle,
                input [WI+WF-1:0]            x_translate, y_translate, z_translate,
                input                        list_read_done,
                output logic [2:0][1:0][9:0] proj_triangle,
                output logic                 list_r,
                output logic                 fifo_w,
                output logic                 proj_done
);

    logic [2:0][2:0][WI+WF-1:0] orig_triangle_data, new_orig_triangle_data;
    logic [3:0]                 cal_time, count, new_count;
    logic                       clip;

    enum logic [2:0] {Wait, Take1, Take2, Proj, Write, Done} curr_state, next_state;

    assign cal_time = 3'd4;

    project_cal #(.WIIA(WIIA), .WIFA(WIFA), .WI(WI), .WF(WF)) pc (
                                                            .orig_triangle(orig_triangle_data),
                                                            .angle(angle),
                                                            .x_translate(x_translate),
                                                            .y_translate(y_translate),
                                                            .z_translate(z_translate),
                                                            .proj_triangle(proj_triangle),
                                                            .clip(clip)
    );

    always_ff @(posedge Clk)
    begin
        if (Reset)
        begin
            curr_state <= Wait;
            orig_triangle_data <= 0;
            count <= 0;
        end
        else
        begin
            curr_state <= next_state;
            orig_triangle_data <= new_orig_triangle_data;
            count <= new_count;
        end
    end

    always_comb
    begin
        next_state = curr_state;
        proj_done = 1'b0;
        list_r = 1'b0;
        fifo_w = 1'b0;
        new_orig_triangle_data = orig_triangle_data;
        new_count = 0;
        
        unique case (curr_state)
        Wait:
        begin
            if(proj_start)
                next_state = Take1;
        end
        Take1:
        begin
            if(list_read_done)
                next_state = Done;
            else
                next_state = Take2;
        end
        Take2:
        begin
            if(list_read_done)
                next_state = Done;
            else
                next_state = Proj;
        end
        // Proj1:
        // begin
        //     next_state = Proj2;
        // end
        // Proj2:
        // begin
        //     next_state = Proj3;
        // end
        // Proj3:
        // begin
        //     next_state = Write;
        Proj:
        begin
            if(count == cal_time)
                next_state = Write;
            else
            begin
                next_state = Proj;
                new_count = count + 3'b1;
            end
        end
        Write:
        begin
            next_state = Take1;
        end
        Done:
        begin
            if(!proj_start)
                next_state = Wait;
        end
        endcase

        case (curr_state)
        Wait:
        begin
        end
        Take1:
        begin
            list_r = 1'b1;
            new_orig_triangle_data = orig_triangle;
        end
        Take2:
        begin
            new_orig_triangle_data = orig_triangle;
        end
        // Proj1:
        // begin
        // end
        // Proj2:
        // begin
        // end
        // Proj3:
        // begin
        // end
        Proj:
        begin
        end
        Write:
        begin
            if(!clip)
                fifo_w = 1'b1;
        end
        Done:
        begin
            proj_done = 1'b1;
        end
        endcase
    end

endmodule