module get_mvp_matrix # (
    // input matrix 
    parameter WII= 8,
    parameter WIF = 8,
    // output matrix
    parameter WOI = 8,
    parameter WOF = 8
)
(
    input           [15:0][WII+WIF-1:0] model_matrix, view_matrix, projection_matrix,
    output logic    [15:0][WOI+WOF-1:0] mvp_matrix
);

logic [15:0][WOI+WOF-1:0]   tmp_mvp;

matrix_multiplier # (
    .WII(WII), 
    .WIF(WIF),
    .WOI(WOI), 
    .WOF(WOF)
) mm0 (
    .matA(projection_matrix),
    .matB(view_matrix),
    .res_mat(tmp_mvp)
);

matrix_multiplier # (
    .WII(WII), 
    .WIF(WIF),
    .WOI(WOI), 
    .WOF(WOF)
) mm1 (
    .matA(tmp_mvp),
    .matB(model_matrix),
    .res_mat(mvp_matrix)
);

endmodule