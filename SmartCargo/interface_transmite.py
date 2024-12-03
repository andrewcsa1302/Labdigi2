import customtkinter as ctk
import serial
import threading
import time

# Configura a conexão serial
try:
    ser = serial.Serial(port='COM11', baudrate=115200, bytesize=serial.SEVENBITS, parity=serial.PARITY_ODD, stopbits=serial.STOPBITS_ONE)
    serial_status = True
except serial.SerialException:
    ser = None
    serial_status = False

# Inicializa a lista de mensagens recebidas
mensagens_recebidas = [{"Mensagem": "-", "Tipo": "-", "Destino": "-"} for _ in range(7)]

# Mapeamento dos tipos de vestimentas
tipo_mapeamento = {
    "01": "Calças",
    "10": "Camisas",
    "11": "Jaquetas",
    "00": "Inválido"
}

# Função para escutar mensagens serial
def escutar_serial():
    global mensagens_recebidas
    while True:
        if serial_status:
            try:
                bloco_mensagens = []  # Armazena um bloco de 7 mensagens
                for i in range(7):
                    mensagem = ser.read(1)  # Lê 1 byte
                    if mensagem:
                        byte = bin(ord(mensagem))[2:].zfill(7)  # Converte para 7 bits
                        if byte[:3] == "111":  # Valida os 3 primeiros bits
                            tipo_bits = byte[3:5]  # Extrai o tipo
                            destino_bits = byte[5:7]  # Extrai o destino

                            tipo_obj = tipo_mapeamento.get(tipo_bits, "Inválido")  # Decodifica tipo
                            destino_obj = int(destino_bits, 2) + 1 if tipo_obj != "Inválido" else "-"  # Mapeia o destino

                            bloco_mensagens.append({"Mensagem": byte, "Tipo": tipo_obj, "Destino": destino_obj})
                        else:
                            bloco_mensagens.append({"Mensagem": byte, "Tipo": "Inválido", "Destino": "-"})
                    else:
                        bloco_mensagens.append({"Mensagem": "Timeout", "Tipo": "Timeout", "Destino": "Timeout"})

                mensagens_recebidas = bloco_mensagens
                atualizar_interface()
            except Exception as e:
                print("Erro ao receber mensagem:", e)
        time.sleep(1)

# Função para atualizar os dados na interface
def atualizar_interface():
    for i, msg in enumerate(mensagens_recebidas):
        mensagem = msg["Mensagem"]
        tipo = msg["Tipo"]
        destino = msg["Destino"]
        mensagem_labels[i]["Mensagem"].configure(text=f"Mensagem: {mensagem}")
        mensagem_labels[i]["Tipo"].configure(text=f"Tipo: {tipo}")
        mensagem_labels[i]["Destino"].configure(text=f"Destino: {destino}")

# Inicia thread para escutar mensagens seriais
threading.Thread(target=escutar_serial, daemon=True).start()

# Configuração principal da interface com customtkinter
ctk.set_appearance_mode("light")
ctk.set_default_color_theme("green")
janela = ctk.CTk()
janela.title("SmartCargo - Monitoramento de Recepção")
janela.geometry("1200x800")

# Frame principal
main_frame = ctk.CTkFrame(janela, corner_radius=20, fg_color="#f0f0f0", width=1000, height=700)
main_frame.place(relx=0.5, rely=0.5, anchor="center")

# Título
titulo_label = ctk.CTkLabel(
    main_frame,
    text="SmartCargo",
    font=("Helvetica", 50, "bold"),
    text_color="#1e81b0"
)
titulo_label.pack(pady=10)

subtitulo_label = ctk.CTkLabel(
    main_frame,
    text="Monitoramento de Recepção",
    font=("Helvetica", 25, "italic"),
    text_color="#126e94"
)
subtitulo_label.pack(pady=10)

# Indicador de Status da Conexão
status_label = ctk.CTkLabel(
    main_frame,
    text="Conexão Serial Ativa" if serial_status else "Conexão Serial Inativa",
    font=("Helvetica", 25),
    text_color="green" if serial_status else "red"
)
status_label.pack(pady=10)

# Frame para mensagens recebidas
mensagens_frame = ctk.CTkFrame(main_frame, corner_radius=10, fg_color="#ffffff")
mensagens_frame.pack(pady=20)

# Exibição das mensagens recebidas
mensagem_labels = []
for i in range(7):
    frame = ctk.CTkFrame(mensagens_frame, corner_radius=10, fg_color="#f9f9f9")
    frame.pack(pady=5, padx=10, fill="x")
    mensagem_label = ctk.CTkLabel(frame, text="Mensagem: -", font=("Helvetica", 20), anchor="w", width=400)
    mensagem_label.grid(row=0, column=0, padx=10)
    tipo_label = ctk.CTkLabel(frame, text="Tipo: -", font=("Helvetica", 20), anchor="w", width=200)
    tipo_label.grid(row=0, column=1, padx=10)
    destino_label = ctk.CTkLabel(frame, text="Destino: -", font=("Helvetica", 20), anchor="w", width=200)
    destino_label.grid(row=0, column=2, padx=10)
    mensagem_labels.append({"Mensagem": mensagem_label, "Tipo": tipo_label, "Destino": destino_label})

# Exibição de logs de resposta
resposta_label = ctk.CTkLabel(main_frame, text="Recepção de mensagens aguardando...", font=("Helvetica", 20), text_color="gray")
resposta_label.pack(pady=20)

janela.mainloop()
