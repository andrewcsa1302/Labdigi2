/*
 *  Arquivo   : mux_8x1_n_tb.sv
 * ----------------------------------------------------------------
 *  Descricao : testbench do modulo multiplexador 8x1  
 * 
 *  > descricao em SystemVerilog 
 *  > implementa verificacao com vetor de teste
 * 
 * ----------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      27/09/2024  1.0     Andrew Carvalho   Novo componente baseado no 4x1
 * ----------------------------------------------------------------
 */
 
`timescale 1ns / 1ns

module mux_8x1_n_tb;

    parameter BITS = 4;

    logic [BITS-1:0] D7_IN, D6_IN, D5_IN, D4_IN, D3_IN, D2_IN, D1_IN, D0_IN;
    logic [2:0]      SEL_IN;
    wire [BITS-1:0]  MUX_OUT;

    mux_8x1_n #(BITS) dut (
        .D7     (D7_IN  ),
        .D6     (D6_IN  ),
        .D5     (D5_IN  ),
        .D4     (D4_IN  ),
        .D3     (D3_IN  ),
        .D2     (D2_IN  ),
        .D1     (D1_IN  ),
        .D0     (D0_IN  ),
        .SEL    (SEL_IN ),
        .MUX_OUT(MUX_OUT)
    );

    logic [BITS-1:0] vetor_teste [9:0][9:0];

    initial begin
        // inicializa vetor de teste com diversos casos de teste
        //                D7_IN, D6_IN, D5_IN, D4_IN, D3_IN, D2_IN, D1_IN, D0_IN, SEL_OUT, MUX_OUT (saida esperada)
        vetor_teste[0] = {4'h0,  4'h0,  4'h0,  4'h0,  4'h0,  4'h0,  4'h0,  4'h0,  3'b000, 4'h0};  // entradas em 0, SEL = 0
        vetor_teste[1] = {4'hF,  4'hF,  4'hF,  4'hF,  4'hF,  4'hF,  4'hF,  4'hF,  3'b111, 4'hF};  // entradas em F, SEL = 7
        vetor_teste[2] = {4'h3,  4'h2,  4'h1,  4'h0,  4'h7,  4'h6,  4'h5,  4'h4,  3'b000, 4'h4};  // entradas 3,2,1,0,7,6,5,4, SEL = 0
        vetor_teste[3] = {4'h3,  4'h2,  4'h1,  4'h0,  4'h7,  4'h6,  4'h5,  4'h4,  3'b001, 4'h5};  // entradas 3,2,1,0,7,6,5,4, SEL = 1
        vetor_teste[4] = {4'h3,  4'h2,  4'h1,  4'h0,  4'h7,  4'h6,  4'h5,  4'h4,  3'b010, 4'h6};  // entradas 3,2,1,0,7,6,5,4, SEL = 2
        vetor_teste[5] = {4'h3,  4'h2,  4'h1,  4'h0,  4'h7,  4'h6,  4'h5,  4'h4,  3'b011, 4'h7};  // entradas 3,2,1,0,7,6,5,4, SEL = 3
        vetor_teste[6] = {4'h3,  4'h3,  4'h3,  4'h3,  4'h3,  4'h3,  4'h3,  4'h3,  3'b010, 4'h3};  // entradas iguais, SEL = 2
        vetor_teste[7] = {4'hE,  4'h2,  4'hC,  4'h5,  4'hA,  4'h9,  4'h8,  4'h7,  3'b000, 4'h7};  // entradas variadas, SEL = 0
        vetor_teste[8] = {4'h5,  4'hB,  4'h5,  4'hB,  4'h5,  4'hB,  4'h5,  4'hB,  3'b111, 4'h5};  // entradas variadas, SEL = 7
        vetor_teste[9] = {4'h1,  4'h2,  4'h3,  4'h4,  4'h5,  4'h6,  4'h7,  4'h8,  3'b000, 4'h8};  // entradas variadas, SEL = 0

        $display("inicio da simulacao");

        // percorre casos de teste
        for (int caso = 0; caso < 10; caso++) begin

            // seleciona entradas presentes no vetor de teste
            D7_IN  = vetor_teste[caso][9]; 
            D6_IN  = vetor_teste[caso][8]; 
            D5_IN  = vetor_teste[caso][7]; 
            D4_IN  = vetor_teste[caso][6]; 
            D3_IN  = vetor_teste[caso][5]; 
            D2_IN  = vetor_teste[caso][4]; 
            D1_IN  = vetor_teste[caso][3]; 
            D0_IN  = vetor_teste[caso][2]; 
            SEL_IN = vetor_teste[caso][1]; 

            // intervalo de tempo
            #20;

            // apenas imprime valores do caso de teste presentes no vetor de teste
            // $display("caso %d: SEL=%b, D0=%h, D1=%h, D2=%h, D3=%h, D4=%h, D5=%h, D6=%h, D7=%h, MUX_OUT=%h (esperado=%h)",
                     // caso, SEL_IN, D0_IN, D1_IN, D2_IN, D3_IN, D4_IN, D5_IN, D6_IN, D7_IN, MUX_OUT, vetor_teste[caso][0]);

            // verifica saida do mux com o valor esperado presente no vetor de teste
            if (MUX_OUT != vetor_teste[caso][0])
                $display("caso %d: TESTE FALHOU! SEL=%b, D0=%h, D1=%h, D2=%h, D3=%h, D4=%h, D5=%h, D6=%h, D7=%h, MUX_OUT=%h (esperado=%h)",
                         caso, SEL_IN, D0_IN, D1_IN, D2_IN, D3_IN, D4_IN, D5_IN, D6_IN, D7_IN, MUX_OUT, vetor_teste[caso][0]);
            else
                $display("caso %d: TESTE OK! SEL=%b, D0=%h, D1=%h, D2=%h, D3=%h, D4=%h, D5=%h, D6=%h, D7=%h, MUX_OUT=%h (esperado=%h)",
                         caso, SEL_IN, D0_IN, D1_IN, D2_IN, D3_IN, D4_IN, D5_IN, D6_IN, D7_IN, MUX_OUT, vetor_teste[caso][0]);
        end

        $display("fim da simulacao");
        $stop; 
    end

endmodule