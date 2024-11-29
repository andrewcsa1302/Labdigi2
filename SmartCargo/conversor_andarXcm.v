module conversor_andarXcm #(parameter EPS = 2, h0 = 6, h1 = 15, h2 = 30, h3 = 40) ( // epsolon é o erro aceito, para mais ou para menos
    input reset,
    input [3:0] unidades,  
    input [3:0] dezenas,    
    input [3:0] centenas,   
    output reg [1:0] andar_exato,  
    output reg [1:0] andar_aproximado
);

reg [9:0] altura;

always @(posedge reset) begin // inicializacao dos parametros
    andar_exato = 2'b00;
    andar_aproximado = 2'b00;
end

always @(*) begin
    
    altura = (centenas * 100) + (dezenas * 10) + unidades;

    if ((altura < h0 + EPS ) & (altura > h0 - EPS )) begin
        andar_exato = 2'b00;
    end else if ((altura < h1 + EPS ) & (altura > h1 - EPS )) begin
        andar_exato = 2'b01;
    end else if ((altura < h2 + EPS ) & (altura > h2 - EPS )) begin
        andar_exato = 2'b10;
    end else if ((altura < h3 + EPS ) & (altura > h3 - EPS )) begin
        andar_exato = 2'b11;
    end

    // esta sem else -> vai ficar em stX ate receber uma atribuicao
    
    // Serve para identificar a posicao atual do elevador, 
    // mas nao fica em uma faixa entao nao serve quando o elevador estiver em movimento
    if (altura < h0 + EPS) begin
        andar_aproximado = 2'b00; 
    end else if (altura < h1 + EPS) begin
        andar_aproximado = 2'b01; 
    end else if (altura < h2 + EPS) begin
        andar_aproximado = 2'b10; 
    end else if (altura < h3 + EPS) begin
        andar_aproximado = 2'b11; 
    end else begin
        andar_aproximado = 2'b11;
    end
end

endmodule
