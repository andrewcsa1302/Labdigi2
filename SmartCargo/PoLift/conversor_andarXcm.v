module conversor_andarXcm (
    input [3:0] unidades,  
    input [3:0] dezenas,    
    input [3:0] centenas,   
    output reg [1:0] andar 
);

always @(*) begin
    
    int altura = (centenas * 100) + (dezenas * 10) + unidades;
    
    if (altura < 30) begin
        andar = 2'b00; 
    end else if (altura < 60) begin
        andar = 2'b01; 
    end else if (altura < 90) begin
        andar = 2'b10; 
    end else if (altura < 120) begin
        andar = 2'b11; 
    end else begin
        andar = 2'b00;
    end
end

endmodule
