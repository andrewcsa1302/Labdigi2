module interpretador_serial(
    input clock,
    input reset, 
    input [7:0] dados_serial_recebido,
    output reg chegou_sinal_controle,
    output reg iniciar_serial,
    output reg reset_serial,
    output reg emergencia_serial
);
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            iniciar_serial <= 1'b0;
            reset_serial <= 1'b0;
            emergencia_serial <= 1'b0;
            chegou_sinal_controle <= 1'b0;
        end else begin
            if (dados_serial_recebido[7] == 1'b1) begin
                iniciar_serial <= dados_serial_recebido[0];
                reset_serial <= dados_serial_recebido[2];
                emergencia_serial <= dados_serial_recebido[4];
                chegou_sinal_controle <= 1'b1;
            end else begin
            iniciar_serial <= iniciar_serial;
            reset_serial <= reset_serial;
            emergencia_serial <= emergencia_serial;
            chegou_sinal_controle <= 1'b0;
        end
        end
    end
endmodule