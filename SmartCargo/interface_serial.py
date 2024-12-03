import tkinter as tk
import customtkinter as ctk
import serial

# Configura a conexão serial
try:
    ser = serial.Serial(port='COM10', baudrate=115200, bytesize=serial.EIGHTBITS, timeout=1)
    serial_status = True
except serial.SerialException:
    ser = None
    serial_status = False

# Mapeamento de objetos
mapa_objetos = {"Calça": "00", "Camisa": "01", "Jaqueta": "10"}

# Função para enviar mensagens específicas de Reset e Emergência
def enviar_mensagem(mensagem_bin):
    if serial_status:
        ser.write(int(mensagem_bin, 2).to_bytes(1, byteorder="big"))
        resposta_label.configure(text=f"Dado enviado: {mensagem_bin} (binário).")
    else:
        resposta_label.configure(text="Erro: Conexão serial não estabelecida.", text_color="red")

# Função para enviar os dados gerais
def enviar_serial():
    tipo_obj = tipo_obj_combobox.get()
    destino_obj = destino_obj_entry.get()
    origem_obj = origem_obj_entry.get()
    reset_state = reset_toggle.get()
    emergencia_state = emergencia_toggle.get()

    # Validação das entradas
    if tipo_obj not in mapa_objetos:
        resposta_label.configure(text="Erro: Selecione um tipo de objeto válido.", text_color="red")
        return
    if not (destino_obj.isdigit() and origem_obj.isdigit()):
        resposta_label.configure(text="Erro: Origem e Destino devem conter números válidos.", text_color="red")
        return
    if not (1 <= int(destino_obj) <= 4 and 1 <= int(origem_obj) <= 4):
        resposta_label.configure(text="Erro: Origem e Destino devem estar entre 1 e 4.", text_color="red")
        return

    # Montagem do byte de dados
    tipo_obj_bits = mapa_objetos[tipo_obj]
    destino_obj_bits = f"{int(destino_obj) - 1:02b}"  # Subtração para converter de 1-4 para 0-3
    origem_obj_bits = f"{int(origem_obj) - 1:02b}"   # Subtração para converter de 1-4 para 0-3
    reset_bit = f"{reset_state}"
    emergencia_bit = f"{emergencia_state}"
    dados_bin = f"{emergencia_bit}{reset_bit}{tipo_obj_bits}{destino_obj_bits}{origem_obj_bits}"

    # Envia os dados
    enviar_mensagem(dados_bin)

# Função para o toggle de Reset
def toggle_reset():
    reset_state = reset_toggle.get()
    if reset_state == 1:  # Reset ON
        enviar_mensagem("10001100")
    else:  # Reset OFF
        enviar_mensagem("10001000")

# Função para o toggle de Emergência
def toggle_emergencia():
    emergencia_state = emergencia_toggle.get()
    if emergencia_state == 1:  # Emergência ON
        enviar_mensagem("10110000")
    else:  # Emergência OFF
        enviar_mensagem("10100000")

# Configuração principal da interface com customtkinter
ctk.set_appearance_mode("light")  # Modo claro
ctk.set_default_color_theme("green")  # Tema verde
janela = ctk.CTk()  # Janela principal
janela.title("SmartCargo - Elevador Inteligente de Roupas")
janela.geometry("1200x800")

# Frame principal para centralizar tudo
main_frame = ctk.CTkFrame(janela, corner_radius=20, fg_color="#f0f0f0", width=1000, height=700)
main_frame.place(relx=0.5, rely=0.5, anchor="center")

# Configuração do título
titulo_label = ctk.CTkLabel(
    main_frame,
    text="SmartCargo",
    font=("Helvetica", 50, "bold"),
    text_color="#1e81b0"
)
titulo_label.pack(pady=10)

subtitulo_label = ctk.CTkLabel(
    main_frame,
    text="Elevador Inteligente de Roupas",
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

# Entradas de Tipo, Origem e Destino
input_frame = ctk.CTkFrame(main_frame, corner_radius=15)
input_frame.pack(pady=20)

# Combobox para Tipo do Objeto
ctk.CTkLabel(input_frame, text="Tipo do Objeto:", font=("Helvetica", 25)).grid(row=0, column=0, padx=15, pady=10, sticky="e")
tipo_obj_combobox = ctk.CTkComboBox(input_frame, values=list(mapa_objetos.keys()), font=("Helvetica", 25), width=350)
tipo_obj_combobox.grid(row=0, column=1, padx=15, pady=10)
tipo_obj_combobox.set("Calça")  # Valor padrão

# Campo de entrada para Origem
ctk.CTkLabel(input_frame, text="Origem (1 a 4):", font=("Helvetica", 25)).grid(row=1, column=0, padx=15, pady=10, sticky="e")
origem_obj_entry = ctk.CTkEntry(input_frame, width=350, font=("Helvetica", 25))
origem_obj_entry.grid(row=1, column=1, padx=15, pady=10)
origem_obj_entry.insert(0, "1")

# Campo de entrada para Destino
ctk.CTkLabel(input_frame, text="Destino (1 a 4):", font=("Helvetica", 25)).grid(row=2, column=0, padx=15, pady=10, sticky="e")
destino_obj_entry = ctk.CTkEntry(input_frame, width=350, font=("Helvetica", 25))
destino_obj_entry.grid(row=2, column=1, padx=15, pady=10)
destino_obj_entry.insert(0, "1")

# Botão para enviar dados
enviar_button = ctk.CTkButton(
    main_frame,
    text="Enviar Dados",
    command=enviar_serial,
    font=("Helvetica", 30, "bold"),
    fg_color="#1e81b0",
    hover_color="#126e94",
    width=400,
    height=60
)
enviar_button.pack(pady=30)

# Toggles para Reset e Emergência
toggle_frame = ctk.CTkFrame(main_frame, corner_radius=10)
toggle_frame.pack(pady=20)

reset_toggle = ctk.CTkSwitch(toggle_frame, text="Reset", font=("Helvetica", 25), command=toggle_reset, onvalue=1, offvalue=0)
reset_toggle.grid(row=0, column=0, padx=80, pady=10)

emergencia_toggle = ctk.CTkSwitch(toggle_frame, text="Emergência", font=("Helvetica", 25), command=toggle_emergencia, onvalue=1, offvalue=0)
emergencia_toggle.grid(row=0, column=1, padx=80, pady=10)

# Exibição de resposta
resposta_label = ctk.CTkLabel(main_frame, text="", font=("Helvetica", 20))
resposta_label.pack(pady=30)

janela.mainloop()
