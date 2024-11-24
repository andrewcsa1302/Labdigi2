module comparador_85 # (parameter N=4)(
    input  [N-1:0] A, B,
    input          ALBi, AGBi, AEBi,
    output         ALBo, AGBo, AEBo
);

    wire [N:0] CSL, CSG;

    assign CSL  = {1'b0, ~A} + {1'b0, B} + ALBi;
    assign ALBo = ~CSL[N];
    assign CSG  = {1'b0, A} + {1'b0, ~B} + AGBi;
    assign AGBo = ~CSG[N];
    assign AEBo = ((A == B) && AEBi);

endmodule