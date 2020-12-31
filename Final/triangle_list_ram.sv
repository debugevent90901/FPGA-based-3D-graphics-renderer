// On-chip memeory list
module triangle_list_ram # (
    parameter WI = 8,
    parameter WF = 8,
    parameter Waddr = 7,
    parameter size = 100
)
(
    input                        Clk,
    input                        r_en, w_en,
    input [Waddr-1:0]             r_addr,w_addr,
    input                        is_empty, is_full,
    input [(WI+WF)*9-1:0]        data_in,
    output logic [(WI+WF)*9-1:0] data_out
);

    reg [(WI+WF)*9-1:0] list [size:0];
    
    // initial
    // begin
    //     $readmemh("./dodecahedron.txt", list);
    // end

    always @(posedge Clk)
    begin
        if(r_en && !is_empty)
            data_out<=list[r_addr];
    end
    always @(posedge Clk)
    begin
        if(w_en && !is_full)
            list[w_addr]<=data_in;
    end

endmodule