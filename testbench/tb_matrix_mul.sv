module tb_matrix_mul();

timeunit 10ns;
timeprecision 1ns;

logic [15:0][15:0] ina;
logic [15:0][15:0] inb;
logic [15:0][15:0] out;

matrix_multiplier mat_mul(
    .matA      ( ina      ),
    .matB      ( inb      ),
    .res_mat   ( out      )
);


initial begin
    // ina[0] = 16'h0100;
    // ina[1] = 16'h0200;
    // ina[2] = 16'h0300;
    // ina[3] = 16'h0400;
    // ina[4] = 16'h0200;
    // ina[5] = 16'h0300;
    // ina[6] = 16'h0400;
    // ina[7] = 16'h0500;
    // ina[8] = 16'h0300;
    // ina[9] = 16'h0200;
    // ina[10] = 16'h0100;
    // ina[11] = 16'h0400;
    // ina[12] = 16'h0400;
    // ina[13] = 16'h0300;
    // ina[14] = 16'h0200;
    // ina[15] = 16'h0100;

    // # 5
    // inb[0] = 16'h0100;
    // inb[1] = 16'h0100;
    // inb[2] = 16'h0200;
    // inb[3] = 16'h0200;
    // inb[4] = 16'h0300;
    // inb[5] = 16'h0300;
    // inb[6] = 16'h0400;
    // inb[7] = 16'h0400;
    // inb[8] = 16'h0100;
    // inb[9] = 16'h0200;
    // inb[10] = 16'h0100;
    // inb[11] = 16'h0200;
    // inb[12] = 16'h0300;
    // inb[13] = 16'h0100;
    // inb[14] = 16'h0300;
    // inb[15] = 16'h0100;

    ina[0] = 16'h0123;
    ina[1] = 16'h0245;
    ina[2] = 16'h0378;
    ina[3] = 16'h0421;
    ina[4] = 16'h0256;
    ina[5] = 16'h0318;
    ina[6] = 16'h0493;
    ina[7] = 16'h0534;
    ina[8] = 16'h0388;
    ina[9] = 16'h0222;
    ina[10] = 16'h0111;
    ina[11] = 16'h0400;
    ina[12] = 16'h0476;
    ina[13] = 16'h0356;
    ina[14] = 16'h0278;
    ina[15] = 16'h0141;

    # 5
    inb[0] = 16'h0159;
    inb[1] = 16'h0182;
    inb[2] = 16'h0221;
    inb[3] = 16'h0287;
    inb[4] = 16'h0371;
    inb[5] = 16'h0319;
    inb[6] = 16'h0456;
    inb[7] = 16'h0452;
    inb[8] = 16'h0102;
    inb[9] = 16'h0270;
    inb[10] = 16'h0183;
    inb[11] = 16'h0233;
    inb[12] = 16'h0311;
    inb[13] = 16'h0176;
    inb[14] = 16'h0347;
    inb[15] = 16'h0106;

    $display("matB");
    $display($signed(inb[0])*1.0/(1<<8));
    $display($signed(inb[1])*1.0/(1<<8));
    $display($signed(inb[2])*1.0/(1<<8));
    $display($signed(inb[3])*1.0/(1<<8));
    $display($signed(inb[4])*1.0/(1<<8));
    $display($signed(inb[5])*1.0/(1<<8));
    $display($signed(inb[6])*1.0/(1<<8));
    $display($signed(inb[7])*1.0/(1<<8));
    $display($signed(inb[8])*1.0/(1<<8));
    $display($signed(inb[9])*1.0/(1<<8));
    $display($signed(inb[10])*1.0/(1<<8));
    $display($signed(inb[11])*1.0/(1<<8));
    $display($signed(inb[12])*1.0/(1<<8));
    $display($signed(inb[13])*1.0/(1<<8));
    $display($signed(inb[14])*1.0/(1<<8));
    $display($signed(inb[15])*1.0/(1<<8));

    $display("matA");
    $display($signed(ina[0])*1.0/(1<<8));
    $display($signed(ina[1])*1.0/(1<<8));
    $display($signed(ina[2])*1.0/(1<<8));
    $display($signed(ina[3])*1.0/(1<<8));
    $display($signed(ina[4])*1.0/(1<<8));
    $display($signed(ina[5])*1.0/(1<<8));
    $display($signed(ina[6])*1.0/(1<<8));
    $display($signed(ina[7])*1.0/(1<<8));
    $display($signed(ina[8])*1.0/(1<<8));
    $display($signed(ina[9])*1.0/(1<<8));
    $display($signed(ina[10])*1.0/(1<<8));
    $display($signed(ina[11])*1.0/(1<<8));
    $display($signed(ina[12])*1.0/(1<<8));
    $display($signed(ina[13])*1.0/(1<<8));
    $display($signed(ina[14])*1.0/(1<<8));
    $display($signed(ina[15])*1.0/(1<<8));

    # 5
    $display("res");
    $display($signed(out[0])*1.0/(1<<8));
    $display($signed(out[1])*1.0/(1<<8));
    $display($signed(out[2])*1.0/(1<<8));
    $display($signed(out[3])*1.0/(1<<8));
    $display($signed(out[4])*1.0/(1<<8));
    $display($signed(out[5])*1.0/(1<<8));
    $display($signed(out[6])*1.0/(1<<8));
    $display($signed(out[7])*1.0/(1<<8));
    $display($signed(out[8])*1.0/(1<<8));
    $display($signed(out[9])*1.0/(1<<8));
    $display($signed(out[10])*1.0/(1<<8));
    $display($signed(out[11])*1.0/(1<<8));
    $display($signed(out[12])*1.0/(1<<8));
    $display($signed(out[13])*1.0/(1<<8));
    $display($signed(out[14])*1.0/(1<<8));
    $display($signed(out[15])*1.0/(1<<8));






end

endmodule
