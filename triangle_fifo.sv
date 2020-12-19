// custemed Triangle fifo
// Using On-chip memory
// WI: width of integer of coordinate data
// WF: width of float of coordinate data
module triangle_fifo # (
    parameter WI = 8,
    parameter WF = 8,
    parameter size = 10
)
(
    input                                Clk,
    input                                Reset,
    input                                r_en, w_en,
    input [2:0][2:0][(WI+WF)-1:0]        triangle_in,
    output logic [2:0][2:0][(WI+WF)-1:0] triangle_out,
    output logic                         is_empty, is_full
);

logic [size-1:0] r_addr,w_addr;
logic [size-1:0] num;

parameter max = size;

// On-chip memory
triangle_fifo_ram #(.WI(WI), .WF(WF), .size(size)) tfr (
    .Clk(Clk),
    .r_en(r_en), .w_en(w_en),
    .r_addr(r_addr),.w_addr(w_addr),
    .is_empty(is_empty),
    .is_full(is_full),
    .data_in(triangle_in),
    .data_out(triangle_out)
);

assign is_full = (num == max) ? 1'b1 : 1'b0;
assign is_empty = (num == 0) ? 1'b1 : 1'b0;

//generate addr
always @(posedge Clk)
begin
    // generate read addr
    if (Reset)
        r_addr <= 0;
    else if(r_en && !is_empty)
        r_addr <= (r_addr + 1 == size) ? 0 : r_addr + 1;
    // generate write addr
    if (Reset)
        w_addr <= 0;
    else if(w_en && !is_full)
        w_addr <= (w_addr + 1 == size) ? 0 : w_addr + 1;
end

// count the number of elements
always @(posedge Clk)
begin
    if(Reset)
        num <= 0;
    else
    begin
        case({r_en,w_en})
            2'b00: num <= num;
            2'b01: if(num != max) num <= num + 1;
            2'b10: if(num != 0)   num <= num - 1;
            2'b11: num <= num;
            default: num <= num;
        endcase
    end
end

endmodule