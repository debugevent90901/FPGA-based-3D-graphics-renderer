module draw(    input [15:0][15:0] model_matrix, view_matrix, projection_matrix,
                output logic [15:0][15:0] mvp
);

logic [15:0][15:0] tmp_mvp;


matrix_multiplier mm0(.matA(projection_matrix), .matB(view_matrix), .res_mat(tmp_mvp));
matrix_multiplier mm1(.matA(tmp_mvp), .matB(model_matrix), .res_mat(mvp));

endmodule



module dot_product( input [15:0] a0, a1, a2, a3, b0, b1, b2, b3,
                    output logic    [15:0] res
);

logic [15:0] mul_res0, mul_res1, mul_res2, mul_res3;
logic [15:0] add_tmp0, add_tmp1;
logic mul_overflow0, mul_overflow1, mul_overflow2, mul_overflow3;
logic add_overflow0, add_overflow1, add_overflow2;

fxp_mul mul0(.ina(a0), .inb(b0), .out(mul_res0), .overflow(overflow0));
fxp_mul mul1(.ina(a1), .inb(b1), .out(mul_res1), .overflow(overflow1));
fxp_mul mul2(.ina(a2), .inb(b2), .out(mul_res2), .overflow(overflow2));
fxp_mul mul3(.ina(a3), .inb(b3), .out(mul_res3), .overflow(overflow3));

fxp_add add0(.ina(mul_res0), .inb(mul_res1), .out(add_tmp0), .overflow(add_overflow0));
fxp_add add1(.ina(add_tmp0), .inb(mul_res2), .out(add_tmp1), .overflow(add_overflow1));
fxp_add add2(.ina(add_tmp1), .inb(mul_res3), .out(res), .overflow(add_overflow2));

endmodule



module matrix_multiplier(  input           [15:0][15:0] matA, matB,
                                        output logic    [15:0][15:0] res_mat
);

dot_product dp0(.a0(matA[0]), .a1(matA[1]), .a2(matA[2]), .a3(matA[3]), .b0(matB[0]), .b1(matB[4]), .b2(matB[8]), .b3(matB[12]), .res(res_mat[0]));
dot_product dp1(.a0(matA[0]), .a1(matA[1]), .a2(matA[2]), .a3(matA[3]), .b0(matB[1]), .b1(matB[5]), .b2(matB[9]), .b3(matB[13]), .res(res_mat[1]));
dot_product dp2(.a0(matA[0]), .a1(matA[1]), .a2(matA[2]), .a3(matA[3]), .b0(matB[2]), .b1(matB[6]), .b2(matB[10]), .b3(matB[14]), .res(res_mat[2]));
dot_product dp3(.a0(matA[0]), .a1(matA[1]), .a2(matA[2]), .a3(matA[3]), .b0(matB[3]), .b1(matB[7]), .b2(matB[11]), .b3(matB[15]), .res(res_mat[3]));

dot_product dp4(.a0(matA[4]), .a1(matA[5]), .a2(matA[6]), .a3(matA[7]), .b0(matB[0]), .b1(matB[4]), .b2(matB[8]), .b3(matB[12]), .res(res_mat[4]));
dot_product dp5(.a0(matA[4]), .a1(matA[5]), .a2(matA[6]), .a3(matA[7]), .b0(matB[1]), .b1(matB[5]), .b2(matB[9]), .b3(matB[13]), .res(res_mat[5]));
dot_product dp6(.a0(matA[4]), .a1(matA[5]), .a2(matA[6]), .a3(matA[7]), .b0(matB[2]), .b1(matB[6]), .b2(matB[10]), .b3(matB[14]), .res(res_mat[6]));
dot_product dp7(.a0(matA[4]), .a1(matA[5]), .a2(matA[6]), .a3(matA[7]), .b0(matB[3]), .b1(matB[7]), .b2(matB[11]), .b3(matB[15]), .res(res_mat[7]));

dot_product dp8(.a0(matA[8]), .a1(matA[9]), .a2(matA[10]), .a3(matA[11]), .b0(matB[0]), .b1(matB[4]), .b2(matB[8]), .b3(matB[12]), .res(res_mat[8]));
dot_product dp9(.a0(matA[8]), .a1(matA[9]), .a2(matA[10]), .a3(matA[11]), .b0(matB[1]), .b1(matB[5]), .b2(matB[9]), .b3(matB[13]), .res(res_mat[9]));
dot_product dp10(.a0(matA[8]), .a1(matA[9]), .a2(matA[10]), .a3(matA[11]), .b0(matB[2]), .b1(matB[6]), .b2(matB[10]), .b3(matB[14]), .res(res_mat[10]));
dot_product dp11(.a0(matA[8]), .a1(matA[9]), .a2(matA[10]), .a3(matA[11]), .b0(matB[3]), .b1(matB[7]), .b2(matB[11]), .b3(matB[15]), .res(res_mat[11]));

dot_product dp12(.a0(matA[12]), .a1(matA[13]), .a2(matA[14]), .a3(matA[15]), .b0(matB[0]), .b1(matB[4]), .b2(matB[8]), .b3(matB[12]), .res(res_mat[12]));
dot_product dp13(.a0(matA[12]), .a1(matA[13]), .a2(matA[14]), .a3(matA[15]), .b0(matB[1]), .b1(matB[5]), .b2(matB[9]), .b3(matB[13]), .res(res_mat[13]));
dot_product dp14(.a0(matA[12]), .a1(matA[13]), .a2(matA[14]), .a3(matA[15]), .b0(matB[2]), .b1(matB[6]), .b2(matB[10]), .b3(matB[14]), .res(res_mat[14]));
dot_product dp15(.a0(matA[12]), .a1(matA[13]), .a2(matA[14]), .a3(matA[15]), .b0(matB[3]), .b1(matB[7]), .b2(matB[11]), .b3(matB[15]), .res(res_mat[15]));

endmodule


// Verilog fixed-point number lib: custom bit width, arithmetic, converting to float, with single cycle & pipeline version.
// https://github.com/WangXuan95/Verilog-FixedPoint

module fxp_zoom # (
    parameter WII = 8,
    parameter WIF = 8,
    parameter WOI = 8,
    parameter WOF = 8,
    parameter bit ROUND = 1
)
(
    input  logic [WII+WIF-1:0] in,
    output logic [WOI+WOF-1:0] out,
    output logic overflow
);

logic [WII+WOF-1:0] inr;
logic [WII-1:0] ini;
logic [WOI-1:0] outi;
logic [WOF-1:0] outf;

generate if (WOF<WIF) begin
    if(~ROUND) begin
        assign inr = in[WII+WIF-1:WIF-WOF];
    end else if(WII+WOF>=2) begin
        always @ (*) begin
            inr = in[WII+WIF-1:WIF-WOF];
            if(in[WIF-WOF-1] & ~(~inr[WII+WOF-1] & (&inr[WII+WOF-2:0]))) inr++;
        end
    end else begin
        always @ (*) begin
            inr = in[WII+WIF-1:WIF-WOF];
            if(in[WIF-WOF-1] & inr[WII+WOF-1]) inr++;
        end
    end
end else if(WOF==WIF) begin
    assign inr[WII+WOF-1:WOF-WIF] = in;
end else begin
    always @ (*) begin
        inr[WII+WOF-1:WOF-WIF] = in;
        inr[WOF-WIF-1:0] = '0;
    end
end endgenerate

generate if(WOI<WII) begin
    always @ (*) begin
        {ini, outf} = inr;
        overflow = 1'b0;
        outi = ini[WOI-1:0];
        if         ( ~ini[WII-1] & |ini[WII-2:WOI-1] ) begin
            overflow = 1'b1;
            outi[WOI-1] = 1'b0;
            for(int i=0;i<WOI-1;i++) outi[i] = 1'b1;
            outf = '1;
        end else if(  ini[WII-1] & ~(&ini[WII-2:WOI-1]) ) begin
            overflow = 1'b1;
            outi[WOI-1] = 1'b1;
            for(int i=0;i<WOI-1;i++) outi[i] = 1'b0;
            outf = '0;
        end
    end
end else begin
    always @ (*) begin
        {ini, outf} = inr;
        overflow = 1'b0;
        outi[WII-1:0] = ini;
        for(int ii=WII; ii<WOI; ii++) outi[ii] = ini[WII-1];
    end
end endgenerate

assign out = {outi, outf};

endmodule





module fxp_add # (
    parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic [WIIA+WIFA-1:0] ina,
    input  logic [WIIB+WIFB-1:0] inb,
    output logic [WOI +WOF -1:0] out,
    output logic overflow
);

localparam WII = WIIA>WIIB ? WIIA : WIIB;
localparam WIF = WIFA>WIFB ? WIFA : WIFB;
localparam WRI = WII + 1;
localparam WRF = WIF;

wire [WII+WIF-1:0] inaz, inbz;
wire signed [WRI+WRF-1:0] res = $signed(inaz) + $signed(inbz);

fxp_zoom # (
    .WII      ( WIIA     ),
    .WIF      ( WIFA     ),
    .WOI      ( WII      ),
    .WOF      ( WIF      ),
    .ROUND    ( 0        )
) ina_zoom (
    .in       ( ina      ),
    .out      ( inaz     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WIIB     ),
    .WIF      ( WIFB     ),
    .WOI      ( WII      ),
    .WOF      ( WIF      ),
    .ROUND    ( 0        )
) inb_zoom (
    .in       ( inb      ),
    .out      ( inbz     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WRI            ),
    .WIF      ( WRF            ),
    .WOI      ( WOI            ),
    .WOF      ( WOF            ),
    .ROUND    ( ROUND          )
) res_zoom (
    .in       ( $unsigned(res) ),
    .out      ( out            ),
    .overflow ( overflow       )
);

endmodule





module fxp_addsub # (
    parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic [WIIA+WIFA-1:0] ina,
    input  logic [WIIB+WIFB-1:0] inb,
    input  logic sub, // 0=add, 1=sub
    output logic [WOI +WOF -1:0] out,
    output logic overflow
);
localparam WIIBE = WIIB + 1;
localparam   WII = WIIA>WIIBE ? WIIA : WIIBE;
localparam   WIF = WIFA>WIFB  ? WIFA : WIFB;
localparam   WRI = WII + 1;
localparam   WRF = WIF;

wire [WIIBE+WIFB-1:0] inbe;
wire [WII+WIF-1:0] inaz, inbz;
wire [WIIBE+WIFB-1:0] inbv = sub ? ((~inbe)+1) : inbe;
wire signed [WRI+WRF-1:0] res = $signed(inaz) + $signed(inbz);

fxp_zoom # (
    .WII      ( WIIB     ),
    .WIF      ( WIFB     ),
    .WOI      ( WIIBE    ),
    .WOF      ( WIFB     ),
    .ROUND    ( 0        )
) inb_extend (
    .in       ( inb      ),
    .out      ( inbe     ),
    .overflow (          )
);

// seems to have an error here
// should comment the following line?
//assign inbv = sub ? ((~inbe)+1) : inbe;

fxp_zoom # (
    .WII      ( WIIA     ),
    .WIF      ( WIFA     ),
    .WOI      ( WII      ),
    .WOF      ( WIF      ),
    .ROUND    ( 0        )
) ina_zoom (
    .in       ( ina      ),
    .out      ( inaz     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WIIBE    ),
    .WIF      ( WIFB     ),
    .WOI      ( WII      ),
    .WOF      ( WIF      ),
    .ROUND    ( 0        )
) inb_zoom (
    .in       ( inbv     ),
    .out      ( inbz     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WRI            ),
    .WIF      ( WRF            ),
    .WOI      ( WOI            ),
    .WOF      ( WOF            ),
    .ROUND    ( ROUND          )
) res_zoom (
    .in       ( $unsigned(res) ),
    .out      ( out            ),
    .overflow ( overflow       )
);

endmodule





module fxp_mul # (
    parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic [WIIA+WIFA-1:0] ina,
    input  logic [WIIB+WIFB-1:0] inb,
    output logic [WOI +WOF -1:0] out,
    output logic overflow
);

localparam WRI = WIIA + WIIB;
localparam WRF = WIFA + WIFB;

wire signed [WRI+WRF-1:0] res = $signed(ina) * $signed(inb);

fxp_zoom # (
    .WII      ( WRI            ),
    .WIF      ( WRF            ),
    .WOI      ( WOI            ),
    .WOF      ( WOF            ),
    .ROUND    ( ROUND          )
) res_zoom (
    .in       ( $unsigned(res) ),
    .out      ( out            ),
    .overflow ( overflow       )
);

endmodule





module fxp_div #(
	parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic [WIIA+WIFA-1:0] dividend,
    input  logic [WIIB+WIFB-1:0] divisor,
    output logic [WOI +WOF -1:0] out,
    output logic overflow
);

localparam WRI = WOI+WIIB > WIIA ? WOI+WIIB : WIIA;
localparam WRF = WOF+WIFB > WIFA ? WOF+WIFB : WIFA;

logic sign = 1'b0;
logic [WIIA+WIFA-1:0] udividend = '0;
logic [WIIB+WIFB-1:0]  udivisor = '0;
logic [ WRI+ WRF-1:0] acc, acct, divd, divr;

always @ (*) begin  // convert dividend and divisor to positive number
    sign      = dividend[WIIA+WIFA-1] ^ divisor[WIIB+WIFB-1];
    udividend = dividend[WIIA+WIFA-1] ? (~dividend)+1 : dividend;
    udivisor  =  divisor[WIIB+WIFB-1] ? (~ divisor)+1 : divisor ;
end

fxp_zoom # (
    .WII      ( WIIA      ),
    .WIF      ( WIFA      ),
    .WOI      ( WRI       ),
    .WOF      ( WRF       ),
    .ROUND    ( 0         )
) dividend_zoom (
    .in       ( udividend ),
    .out      ( divd      ),
    .overflow (           )
);

fxp_zoom # (
    .WII      ( WIIB      ),
    .WIF      ( WIFB      ),
    .WOI      ( WRI       ),
    .WOF      ( WRF       ),
    .ROUND    ( 0         )
)  divisor_zoom (
    .in       ( udivisor  ),
    .out      ( divr      ),
    .overflow (           )
);

always @ (*) begin
    acc = '0;
    for(int shamt=WOI-1; shamt>=-WOF; shamt--) begin
        if(shamt>=0)
            acct = acc + (divr<<shamt);
        else
            acct = acc + (divr>>(-shamt));
        if( acct <= divd ) begin
            acc = acct;
            out[WOF+shamt] = 1'b1;
        end else
            out[WOF+shamt] = 1'b0;
    end
    
    if(ROUND && ~(&out)) begin
        acct = acc+(divr>>(WOF));
        if(acct-divd<divd-acc)
            out++;
    end
    
    overflow = 1'b0;
    if(sign) begin
        if(out[WOI+WOF-1]) begin
            if(|out[WOI+WOF-2:0]) overflow = 1'b1;
            out[WOI+WOF-1] = 1'b1;
            out[WOI+WOF-2:0] = '0;
        end else begin
            out = (~out)+1;
        end
    end else begin
        if(out[WOI+WOF-1]) begin
            overflow = 1'b1;
            out[WOI+WOF-1] = 1'b0;
            out[WOI+WOF-2:0] = '1;
        end
    end
end

endmodule





module fxp_sin #(   // use Cordic Algorithm
    parameter WII  = 4,
    parameter WIF  = 8,
    parameter WOI  = 2,
    parameter WOF  = 12,
    parameter bit ROUND= 1
)(
    input  logic [WII+WIF-1:0] in,
    output logic [WOI+WOF-1:0] out,
    output logic i_overflow
);

localparam N_ITER = 8;
localparam WRI = 4;
localparam WRF = WOF>WIF ? WOF : WIF;
logic [WRI+WRF-1:0] xinit, target, halfpi, x, y, z, xt;
wire  [WRI+WRF-1:0] atan_table [N_ITER];
logic  overflowc, overflowl;

assign i_overflow = overflowc | overflowl;

fxp_zoom # (WRI,WRF,WOI,WOF,ROUND) out_zoom ( y, out   , overflowc );
fxp_zoom # (WII,WIF,WRI,WRF,    1)  in_zoom (in, target,           );

fxp_zoom # (4,28,WRI,WRF,1)    pi_zoom (32'h1921fb54, halfpi      ,);
fxp_zoom # (4,28,WRI,WRF,1) xinit_zoom (32'h09b75555, xinit       ,);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom0 (32'h0c90fdaa,atan_table[0],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom1 (32'h076b19c1,atan_table[1],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom2 (32'h03eb6ebf,atan_table[2],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom3 (32'h01fd5ba9,atan_table[3],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom4 (32'h00ffaadd,atan_table[4],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom5 (32'h007ff556,atan_table[5],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom6 (32'h003ffeaa,atan_table[6],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom7 (32'h001fffd5,atan_table[7],);

always @ (*) begin
    y = '0;
    overflowl = 1'b0;
    if( target[WRI+WRF-1] )
        overflowl = 1'b1;
    else if( target>halfpi ) begin
        overflowl = 1'b1;
        y[WRF] = 1'b1;
    end else begin
        x = xinit;
        z = '0;
        for(int ii=0; ii<N_ITER; ii++) begin
            xt = (x>>ii);
            if(target > z) begin
                x -= (y>>ii);
                y += xt;
                z += atan_table[ii];
            end else begin
                x += (y>>ii);
                y -= xt;
                z -= atan_table[ii];
            end
        end
    end
end

endmodule


