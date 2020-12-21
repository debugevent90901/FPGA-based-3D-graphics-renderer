module cal_sin # ( 
    parameter WII  = 4,
    parameter WIF  = 8,
    parameter WOI  = 2,
    parameter WOF  = 12,
    parameter bit ROUND= 1
)
(
    input  logic [WII+WIF-1:0] in,
    output logic [WOI+WOF-1:0] out
);

// pi = 3.1415926 = 3.243f69a25b094
// pi/2 = 1.921fb4d12d84a
// 1.5pi = 4.b65f1e73888dc
// 2pi=  6.487ed344b6128

logic overflow0, overflow1, overflow2, overflow3, overflow4;
logic [WII+WIF-1:0] angle_in, angle_out, neg_angle_out;
logic [WII+WIF-1:0] pi_sub_in, in_sub_pi, 2pi_sub_in;

fxp_addsub #(.WIIA(4), .WIFA(8), .WIIB(WII), .WIFB(WIF), .WOI(WII), .WOF(WIF), .ROUND(1)) sub0 (
    .ina(12'h324), 
    .inb(in), 
    .sub(1'b1), 
    .out(pi_sub_in), 
    .overflow(overflow0)
);

fxp_addsub #(.WIIA(WII), .WIFA(WIF), .WIIB(4), .WIFB(8), .WOI(WII), .WOF(WIF), .ROUND(1)) sub1 (
    .ina(in), 
    .inb(12'h324), 
    .sub(1'b1), 
    .out(in_sub_pi), 
    .overflow(overflow1)
);

fxp_addsub #(.WIIA(4), .WIFA(8), .WIIB(WII), .WIFB(WIF), .WOI(WII), .WOF(WIF), .ROUND(1)) sub2 (
    .ina(12'h648), 
    .inb(in), 
    .sub(1'b1), 
    .out(2pi_sub_in), 
    .overflow(overflow2)
);

fxp_sin #(.WII(WII), .WIF(WIF), .WOI(WOI), .WOF(WOF), .ROUND(1)) sin ( 
    .in(angle_in), 
    .out(angle_out), 
    .i_overflow(overflow3)
);

fxp_addsub #(.WIIA(4), .WIFA(8), .WIIB(WII), .WIFB(WIF), .WOI(WII), .WOF(WIF), .ROUND(1)) sub3 (
    .ina(12'h000), 
    .inb(angle_out), 
    .sub(1'b1), 
    .out(neg_angle_out), 
    .overflow(overflow4)
);

always_comb
begin
    if ( in >= 12'h4b6 )
        begin
            angle_in = 2pi_sub_in;
            out = neg_angle_out;
        end
    elif ( in >= 12'h324 )
        begin
            angle_in = in_sub_pi;
            out = neg_angle_out;
        end
    elif ( in >= 12'h192 )
        begin
            angle_in = pi_sub_in;
            out = angle_out;
        end
    else
        begin
            angle_in = in;
            out = angle_out;
        end
end

endmodule





module cal_cos # ( 
    parameter WII  = 4,
    parameter WIF  = 8,
    parameter WOI  = 2,
    parameter WOF  = 12,
    parameter bit ROUND= 1
)
(
    input  logic [WII+WIF-1:0] in,
    output logic [WOI+WOF-1:0] out
);

// pi = 3.1415926 = 3.243f69a25b094
// pi/2 = 1.921fb4d12d84a
// 1.5pi = 4.b65f1e73888dc
// 2pi=  6.487ed344b6128

logic overflow0, overflow1, overflow2, overflow3, overflow4, overflow5;
logic [WII+WIF-1:0] angle_in, angle_out, neg_angle_out;
logic [WII+WIF-1:0] pi_div_2_sub_in, in_sub_pi_div_2, 3pi_div_2_sub_in, in_sub_3pi_div_2;

fxp_addsub #(.WIIA(4), .WIFA(8), .WIIB(WII), .WIFB(WIF), .WOI(WII), .WOF(WIF), .ROUND(1)) sub0 (
    .ina(12'h192), 
    .inb(in), 
    .sub(1'b1), 
    .out(pi_div_2_sub_in), 
    .overflow(overflow0)
);

fxp_addsub #(.WIIA(WII), .WIFA(WIF), .WIIB(4), .WIFB(8), .WOI(WII), .WOF(WIF), .ROUND(1)) sub1 (
    .ina(in), 
    .inb(12'h192), 
    .sub(1'b1), 
    .out(in_sub_pi_div_2), 
    .overflow(overflow1)
);

fxp_addsub #(.WIIA(4), .WIFA(8), .WIIB(WII), .WIFB(WIF), .WOI(WII), .WOF(WIF), .ROUND(1)) sub2 (
    .ina(12'h4b6), 
    .inb(in), 
    .sub(1'b1), 
    .out(3pi_div_2_sub_in), 
    .overflow(overflow2)
);

fxp_addsub #(.WIIA(4), .WIFA(8), .WIIB(WII), .WIFB(WIF), .WOI(WII), .WOF(WIF), .ROUND(1)) sub3 (
    .ina(in), 
    .inb(12'h4b6), 
    .sub(1'b1), 
    .out(in_sub_3pi_div_2), 
    .overflow(overflow3)
);

fxp_sin #(.WII(WII), .WIF(WIF), .WOI(WOI), .WOF(WOF), .ROUND(1)) sin ( 
    .in(angle_in), 
    .out(angle_out), 
    .i_overflow(overflow4)
);

fxp_addsub #(.WIIA(4), .WIFA(8), .WIIB(WII), .WIFB(WIF), .WOI(WII), .WOF(WIF), .ROUND(1)) sub3 (
    .ina(12'h000), 
    .inb(angle_out), 
    .sub(1'b1), 
    .out(neg_angle_out), 
    .overflow(overflow5)
);

always_comb
begin
    if ( in >= 12'h4b6 )
        begin
            angle_in = 3pi_div_2_sub_in;
            out = angle_out;
        end
    elif ( in >= 12'h324 )
        begin
            angle_in = in_sub_3pi_div_2;
            out = neg_angle_out;
        end
    elif ( in >= 12'h192 )
        begin
            angle_in = in_sub_pi_div_2;
            out = neg_angle_out;
        end
    else
        begin
            angle_in = pi_div_2_sub_in;
            out = angle_out;
        end
end

endmodule

