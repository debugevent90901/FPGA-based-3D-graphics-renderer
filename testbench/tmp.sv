module draw(    input [15:0][15:0] model_matrix, view_matrix, projection_matrix,
                input [3:0][15:0] vertex_a, vertex_b, vertex_c,
                output logic [1:0][15:0] v1, v2, v3
);

logic [15:0][15:0] tmp_mvp, mvp;
logic [15:0] x1, y1, w1, x2, y2, w2, x3, y3, w3;
logic [15:0] trash0, trash1, trash2;
logic overflow0, overflow1, overflow2, overflow3, overflow4, overflow5;

matrix_multiplier mm0(.matA(projection_matrix), .matB(view_matrix), .res_mat(tmp_mvp));
matrix_multiplier mm1(.matA(tmp_mvp), .matB(model_matrix), .res_mat(mvp));


dot_product dp00(.a0(mvp[0]), .a1(mvp[1]), .a2(mvp[2]), .a3(mvp[3]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(x1));
dot_product dp01(.a0(mvp[4]), .a1(mvp[5]), .a2(mvp[6]), .a3(mvp[7]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(y1));
dot_product dp02(.a0(mvp[8]), .a1(mvp[9]), .a2(mvp[10]), .a3(mvp[11]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(trash0));
dot_product dp03(.a0(mvp[12]), .a1(mvp[13]), .a2(mvp[14]), .a3(mvp[15]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(w1));

dot_product dp10(.a0(mvp[0]), .a1(mvp[1]), .a2(mvp[2]), .a3(mvp[3]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(x2));
dot_product dp11(.a0(mvp[4]), .a1(mvp[5]), .a2(mvp[6]), .a3(mvp[7]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(y2));
dot_product dp12(.a0(mvp[8]), .a1(mvp[9]), .a2(mvp[10]), .a3(mvp[11]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(trash1));
dot_product dp13(.a0(mvp[12]), .a1(mvp[13]), .a2(mvp[14]), .a3(mvp[15]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(w2));

dot_product dp20(.a0(mvp[0]), .a1(mvp[1]), .a2(mvp[2]), .a3(mvp[3]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(x3));
dot_product dp21(.a0(mvp[4]), .a1(mvp[5]), .a2(mvp[6]), .a3(mvp[7]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(y3));
dot_product dp22(.a0(mvp[8]), .a1(mvp[9]), .a2(mvp[10]), .a3(mvp[11]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(trash2));
dot_product dp23(.a0(mvp[12]), .a1(mvp[13]), .a2(mvp[14]), .a3(mvp[15]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(w3));


fxp_div div0(.dividend(x1), .divisor(w1), .out(v1[0]), .overflow(overflow0));
fxp_div div1(.dividend(y1), .divisor(w1), .out(v1[1]), .overflow(overflow1));

fxp_div div2(.dividend(x2), .divisor(w2), .out(v2[0]), .overflow(overflow2));
fxp_div div3(.dividend(y2), .divisor(w2), .out(v2[1]), .overflow(overflow3));

fxp_div div4(.dividend(x3), .divisor(w3), .out(v3[0]), .overflow(overflow4));
fxp_div div5(.dividend(y3), .divisor(w3), .out(v3[1]), .overflow(overflow5));

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

/* 
fxp_add add0(.ina(x1_normalized), .inb(16'h0100), .out(tmp0), .overflow(overflow6));
fxp_mul mul0(.ina(width), .inb(tmp0), .out(tmp1), .overflow(overflow7));
fxp_mul #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) mul1 (
    .ina(tmp1), 
    .inb(16'h0080), 
    .out(V1[0]), 
    .overflow(overflow8)
);
fxp_add add1(.ina(y1_normalized), .inb(16'h0100), .out(tmp2), .overflow(overflow9));
fxp_mul mul2(.ina(height), .inb(tmp2), .out(tmp3), .overflow(overflow10));
fxp_mul #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) mul3 (
    .ina(tmp3), 
    .inb(16'h0100), 
    .out(V1[1]), 
    .overflow(overflow11)
);

fxp_add add2(.ina(x2_normalized), .inb(16'h0100), .out(tmp4), .overflow(overflow12));
fxp_mul mul4(.ina(width), .inb(tmp4), .out(tmp5), .overflow(overflow13));
fxp_mul #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) mul5 (
    .ina(tmp5), 
    .inb(16'h0080), 
    .out(V2[0]), 
    .overflow(overflow14)
);
fxp_add add3(.ina(y2_normalized), .inb(16'h0100), .out(tmp6), .overflow(overflow15));
fxp_mul mul6(.ina(height), .inb(tmp6), .out(tmp7), .overflow(overflow16));
fxp_mul #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) mul7 (
    .ina(tmp7), 
    .inb(16'h0100), 
    .out(V2[1]), 
    .overflow(overflow17)
);

fxp_add add4(.ina(x3_normalized), .inb(16'h0100), .out(tmp8), .overflow(overflow18));
fxp_mul mul8(.ina(width), .inb(tmp8), .out(tmp9), .overflow(overflow19));
fxp_mul #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) mul9 (
    .ina(tmp9), 
    .inb(16'h0080), 
    .out(V3[0]), 
    .overflow(overflow20)
);
fxp_add add5(.ina(y3_normalized), .inb(16'h0100), .out(tmp10), .overflow(overflow21));
fxp_mul mul10(.ina(height), .inb(tmp10), .out(tmp11), .overflow(overflow22));
fxp_mul #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) mul11 (
    .ina(tmp11),
    .inb(16'h0100), 
    .out(V3[1]), 
    .overflow(overflow23)
);

endmodule
 */
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


