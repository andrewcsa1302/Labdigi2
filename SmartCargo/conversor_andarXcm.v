module conversor_andarXcm (
    input [3:0] unidades,  
    input [3:0] dezenas,    
    input [3:0] centenas,   
    output reg [1:0] andar 
);

    reg [9:0] altura;

always @(*) begin
    
    altura = (centenas * 100) + (dezenas * 10) + unidades;
    
    if (altura < 6) begin
        andar = 2'b00; 
    end else if (altura < 18) begin
        andar = 2'b01; 
    end else if (altura < 35) begin
        andar = 2'b10; 
    end else if (altura < 50) begin
        andar = 2'b11; 
    end else begin
        andar = 2'b00;
    end
end

endmodule
