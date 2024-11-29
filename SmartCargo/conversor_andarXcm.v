module conversor_andarXcm #(parameter EPS = 2, h0 = 6, h1 = 15, h2 = 30, h3 = 40) (
    input reset,
    input clock,
    input [3:0] unidades,  
    input [3:0] dezenas,    
    input [3:0] centenas,   
    output reg [1:0] andar_exato,  
    output reg [1:0] andar_aproximado,
    output reg mudou_andar
);

reg [9:0] altura;

always @(posedge reset or posedge clock) begin
    if (reset) begin // Reset condition
        andar_exato <= 2'b00;
        andar_aproximado <= 2'b00;
        altura <= 10'b0;
        mudou_andar <= 1'b0;
    end else begin
        altura <= (centenas * 100) + (dezenas * 10) + unidades;

        // Assignments for andar_exato
        if ((altura < h0 + EPS) & (altura > h0 - EPS)) begin
            andar_exato <= 2'b00;
            mudou_andar <= 1'b1;
        end else if ((altura < h1 + EPS) & (altura > h1 - EPS)) begin
            andar_exato <= 2'b01;
            mudou_andar <= 1'b1;
        end else if ((altura < h2 + EPS) & (altura > h2 - EPS)) begin
            andar_exato <= 2'b10;
            mudou_andar <= 1'b1;
        end else if ((altura < h3 + EPS) & (altura > h3 - EPS)) begin
            andar_exato <= 2'b11;
            mudou_andar <= 1'b1;
        end else begin
            mudou_andar <= 1'b0;
        end

        // Assignments for andar_aproximado
        if (altura < h0 + EPS) begin
            andar_aproximado <= 2'b00; 
        end else if (altura < h1 + EPS) begin
            andar_aproximado <= 2'b01; 
        end else if (altura < h2 + EPS) begin
            andar_aproximado <= 2'b10; 
        end else begin
            andar_aproximado <= 2'b11; 
        end
    end
end

endmodule
