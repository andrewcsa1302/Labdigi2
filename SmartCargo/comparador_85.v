module comparador_85  #(parameter N=4)(ALBi, AGBi, AEBi, A, B, ALBo, AGBo, AEBo);

    input[N-1:0] A, B;
    input      ALBi, AGBi, AEBi;
    output     ALBo, AGBo, AEBo;
    wire[N:0]  CSL, CSG;

    assign CSL  = ~A + B + ALBi;
    assign ALBo = ~CSL[N];
    assign CSG  = A + ~B;
    assign AGBo = ~CSG[N];
    assign AEBo = ((A == B) && AEBi);

endmodule 