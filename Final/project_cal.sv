module project_cal#(
                    parameter WIIA = 4,
                    parameter WIFA = 8,
                    parameter WI = 8,
                    parameter WF = 8
)
(
                    input [2:0][2:0][WI+WF-1:0]  orig_triangle,
                    input [WIIA+WIFA-1:0]        alpha, beta, gamma,
                    input [WI+WF-1:0]            x_translate, y_translate, z_translate,
                    output logic [2:0][1:0][9:0] proj_triangle,
                    output logic                 clip
);

logic [15:0][WI+WF-1:0] model_matrix;
logic [15:0][WI+WF-1:0] view_matrix;
logic [15:0][WI+WF-1:0] projection_matrix;
logic [15:0][WI+WF-1:0] mvp_matrix;

logic [3:0][WI+WF-1:0]  vertex_a, vertex_b, vertex_c;
logic [1:0][11:0]        V1, V2, V3;

logic [11:0]            width, height;
logic [WI+WF-1:0]       scale;
logic [WI+WF-1:0]       x_pos, y_pos, z_pos;
logic [WI+WF-1:0]       inv_tan, aspect_ratio, z_near, z_far;

assign vertex_a = {{{(WI-1){1'b0}},1'b1,{WF{1'b0}}}, orig_triangle[0]};
assign vertex_b = {{{(WI-1){1'b0}},1'b1,{WF{1'b0}}}, orig_triangle[1]};
assign vertex_c = {{{(WI-1){1'b0}},1'b1,{WF{1'b0}}}, orig_triangle[2]};

assign proj_triangle = {{V1[1][9:0],V1[0][9:0]}, {V2[1][9:0],V2[0][9:0]}, {V3[1][9:0],V3[0][9:0]}};

assign width = 12'd640;
assign height = 12'd480;
// assign scale = 16'h0280;
assign scale = 16'h0180;
//assign x_translate = 0;
//assign y_translate = 16'hff80;
//assign z_translate = 0;
assign x_pos =  16'h0000;
assign y_pos =  16'h0000;
assign z_pos =  16'h0a00;
assign inv_tan = 16'h026a;
assign aspect_ratio = 16'h0155;
assign z_near = 16'h001a;
assign z_far = 16'h3200;

// assign width = 10'd640;
// assign height = 10'd480;
// //assign scale = 20'h00280;
// assign scale = 24'h000100;
// assign x_translate = 24'h00000;
// assign y_translate = 24'h00020;
// assign z_translate = 0;
// assign x_pos =  24'h000000;
// assign y_pos =  24'h000000;
// assign z_pos =  24'h000a00;
// assign inv_tan = 24'h00026a;
// assign aspect_ratio = 24'h000100;
// assign z_near = 24'h00001a;
// assign z_far = 24'h003200;

// assign width = 10'd640;
// assign height = 10'd480;
// assign scale = 28'h0000200;
// assign x_translate = 28'h000100;
// assign y_translate = 28'h000000;
// assign z_translate = 0;
// assign x_pos =  28'h0000000;
// assign y_pos =  28'h0000000;
// assign z_pos =  28'h0000a00;
// assign inv_tan = 28'h000026a;
// assign aspect_ratio = 28'h0000100;
// assign z_near = 28'h000001a;
// assign z_far = 28'h0003200;

get_model_matrix #(
                    .WIIA(WIIA), .WIFA(WIFA),
                    .WIIB(WI), .WIFB(WF),
                    .WOIA(2), .WOFA(12),
                    .WOI(WI), .WOF(WF)
) get_model (
            .alpha(alpha),
            .beta(beta),
            .gamma(gamma),
            .scale(scale),
            .x_translate(x_translate),
            .y_translate(y_translate),
            .z_translate(z_translate),
            .model_matrix(model_matrix)
);

get_view_matrix #(
                    .WII(WI),
                    .WIF(WF),
                    .WOI(WI),
                    .WOF(WF)
) get_view (
            .x_pos(x_pos),
            .y_pos(y_pos),
            .z_pos(z_pos),
            .view_matrix(view_matrix)
);

get_projection_matrix #(
                        .WII(WI),
                        .WIF(WF),
                        .WOI(WI),
                        .WOF(WF)
) get_proj (
            .inv_tan(inv_tan),
            .aspect_ratio(aspect_ratio),
            .z_near(z_near),
            .z_far(z_far),
            .projection_matrix(projection_matrix)
);

get_mvp_matrix #(
                    .WII(WI),
                    .WIF(WF),
                    .WOI(WI),
                    .WOF(WF)
) mvp (
        .model_matrix(model_matrix),
        .view_matrix(view_matrix),
        .projection_matrix(projection_matrix),
        .mvp_matrix(mvp_matrix)
);

project_triangle #(
            .WIIA(WI),
            .WIFA(WF),
            .WIIB(12),
            .WIFB(0),
            .WOI(12),
            .WOF(0)
) proj (
        .vertex_a(vertex_a),
        .vertex_b(vertex_b),
        .vertex_c(vertex_c),
        .mvp(mvp_matrix),
        .width(width),
        .height(height),
        .V1(V1),
        .V2(V2),
        .V3(V3),
        .clip(clip)
);

endmodule
