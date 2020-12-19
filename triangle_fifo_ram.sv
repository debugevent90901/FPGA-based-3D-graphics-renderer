// On-chip memeory fifo
module triangle_fifo_ram # (
    parameter WI = 8,
    parameter WF = 8,
    parameter size = 10
)
(
    input                        Clk,
    input                        r_en, w_en,
    input [size-1:0]             r_addr,w_addr,
    input                        is_empty, is_full,
    input [(WI+WF)*9-1:0]        data_in,
    output logic [(WI+WF)*9-1:0] data_out
);

    reg [(WI+WF)*9-1:0] fifo [size-1:0];
    
    always @(posedge Clk)
    begin
        if(r_en && !is_empty)
            data_out<=fifo[r_addr];
    end
    always @(posedge Clk)
    begin
        if(w_en && !is_full)
            fifo[w_addr]<=data_in;
    end

endmodule