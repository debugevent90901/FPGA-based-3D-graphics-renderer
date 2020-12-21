module tb_trigonometric_lib();


logic [11:0] in;
logic [13:0] osin, ocos;

cal_sin #(.WII(4), .WIF(8), .WOI(2), .WOF(12), .ROUND(1)) sin (
    .in(in),
    .out(osin)
);


cal_cos #(.WII(4), .WIF(8), .WOI(2), .WOF(12), .ROUND(1)) cos (
    .in(in),
    .out(ocos)
);


task automatic test(input [11:0] _in);
    in = _in;
#2  $display("    sin %16f =%16f",($signed(in)*1.0)/(1<<8), ($signed(osin)*1.0)/(1<<12));
#2  $display("    cos %16f =%16f",($signed(in)*1.0)/(1<<8), ($signed(ocos)*1.0)/(1<<12));
endtask

// pi = 3.1415926 = 3.243f69a25b094
// pi/2 = 1.921fb4d12d84a
// 1.5pi = 4.b65f1e73888dc
// 2pi=  6.487ed344b6128


initial begin
    test('h08a);
    test('h2a1);
    test('h35b);
    test('h567);
end

endmodule
