import tkinter as tk
from tkinter import messagebox
import ttkbootstrap as ttk
from ttkbootstrap.constants import *
from bitarray import bitarray
import serial

# Configura a conexão serial (ajuste a porta COM e a taxa de baud conforme necessário)
try:
    ser = serial.Serial(port='COM10', baudrate=115200, bytesize=serial.EIGHTBITS)
    serial_status = True
except serial.SerialException:
    serial_status = False

# Função para enviar mensagens específicas de Reset e Emergência
def enviar_mensagem(mensagem_bin):
    if serial_status:
        # Envia os dados em formato de byte
        dados_byte = bitarray(mensagem_bin).tobytes()
        ser.write(dados_byte)
        resposta_label.config(text=f"Dado enviado: {mensagem_bin} (binário).", bootstyle="success")
    else:
        resposta_label.config(text="Erro: Conexão serial não estabelecida.", bootstyle="danger")

# Função para enviar os dados gerais
def enviar_serial():
    tipo_obj = tipo_obj_entry.get()
    destino_obj = destino_obj_entry.get()
    origem_obj = origem_obj_entry.get()
    reset_state = reset_var.get()
    emergencia_state = emergencia_var.get()
    
    # Validação das entradas
    if not (tipo_obj.isdigit() and destino_obj.isdigit() and origem_obj.isdigit()):
        messagebox.showerror("Erro de Entrada", "Todos os campos devem conter números válidos.")
        return
    if not (1 <= int(tipo_obj) <= 3):
        messagebox.showerror("Erro de Tipo do Objeto", "Tipo do Objeto deve estar entre 1 e 3.")
        return
    if not (0 <= int(destino_obj) <= 3 and 0 <= int(origem_obj) <= 3):
        messagebox.showerror("Erro de Destino e Origem", "Destino e Origem devem estar entre 0 e 3.")
        return

    # Conversão para binário e montagem dos 8 bits de dados
    tipo_obj_bits = f"{int(tipo_obj):02b}"        # Representa o valor real
    destino_obj_bits = f"{int(destino_obj):02b}"  # 2 bits para destino_obj
    origem_obj_bits = f"{int(origem_obj):02b}"    # 2 bits para origem_obj
    reset_bit = f"{reset_state:01b}"              # 1 bit para Reset
    emergencia_bit = f"{emergencia_state:01b}"    # 1 bit para Emergência
    
    # Montagem do byte de dados
    dados_bin = f"{emergencia_bit}{reset_bit}{tipo_obj_bits}{destino_obj_bits}{origem_obj_bits}"
    
    # Envia os dados se a conexão serial estiver ativa
    enviar_mensagem(dados_bin)

# Função para o toggle de Reset
def toggle_reset():
    reset_state = reset_var.get()
    if reset_state == 1:  # Reset ON
        enviar_mensagem("10001100")
    else:  # Reset OFF
        enviar_mensagem("10001000")

# Função para o toggle de Emergência
def toggle_emergencia():
    emergencia_state = emergencia_var.get()
    if emergencia_state == 1:  # Emergência ON
        enviar_mensagem("10110000")
    else:  # Emergência OFF
        enviar_mensagem("10100000")

# Configuração principal da interface com ttkbootstrap
janela = ttk.Window(themename="minty")  # Tema moderno e profissional
janela.title("Envio de Dados Serial")
janela.geometry("450x500")

# Título principal
titulo_label = ttk.Label(janela, text="Interface Serial - Envio de Sinais", font=("Helvetica", 16, "bold"))
titulo_label.pack(pady=15)

# Indicador de conexão serial
status_label = ttk.Label(janela, text="Conexão Serial Ativa" if serial_status else "Conexão Serial Inativa", 
                         font=("Helvetica", 10, "italic"), 
                         bootstyle="success" if serial_status else "danger")
status_label.pack(pady=5)

# Separador para organizar a interface
ttk.Separator(janela, orient="horizontal").pack(fill="x", pady=10)

# Campo de entrada para cada informação
frame_inputs = ttk.Frame(janela)
frame_inputs.pack(pady=10)

# Tipo do objeto
ttk.Label(frame_inputs, text="Tipo do Objeto (1 a 3):", font=("Helvetica", 12)).grid(row=0, column=0, padx=5, pady=5, sticky="e")
tipo_obj_entry = ttk.Entry(frame_inputs, width=5, font=("Helvetica", 12))
tipo_obj_entry.grid(row=0, column=1, padx=5, pady=5)
tipo_obj_entry.insert(0, "1")  # Valor padrão para auxiliar o usuário

# Destino do objeto
ttk.Label(frame_inputs, text="Destino do Objeto (0 a 3):", font=("Helvetica", 12)).grid(row=1, column=0, padx=5, pady=5, sticky="e")
destino_obj_entry = ttk.Entry(frame_inputs, width=5, font=("Helvetica", 12))
destino_obj_entry.grid(row=1, column=1, padx=5, pady=5)
destino_obj_entry.insert(0, "0")  # Valor padrão

# Origem do objeto
ttk.Label(frame_inputs, text="Origem do Objeto (0 a 3):", font=("Helvetica", 12)).grid(row=2, column=0, padx=5, pady=5, sticky="e")
origem_obj_entry = ttk.Entry(frame_inputs, width=5, font=("Helvetica", 12))
origem_obj_entry.grid(row=2, column=1, padx=5, pady=5)
origem_obj_entry.insert(0, "0")  # Valor padrão

# Botão de envio com estilo e efeito 3D logo abaixo dos campos
enviar_button = ttk.Button(janela, text="Enviar Dados", command=enviar_serial, bootstyle="primary outline", width=20)
enviar_button.pack(pady=20)

# Toggle para Reset com envio automático
reset_var = tk.IntVar(value=0)  # Estado inicial: desligado
reset_toggle = ttk.Checkbutton(janela, text="Reset", variable=reset_var, command=toggle_reset, bootstyle="switch")
reset_toggle.pack(pady=10)

# Toggle para Emergência com envio automático
emergencia_var = tk.IntVar(value=0)  # Estado inicial: desligado
emergencia_toggle = ttk.Checkbutton(janela, text="Emergência", variable=emergencia_var, command=toggle_emergencia, bootstyle="switch")
emergencia_toggle.pack(pady=10)

# Exibição de resposta com sequência de bits enviada
resposta_label = ttk.Label(janela, text="", font=("Helvetica", 12))
resposta_label.pack(pady=10)

janela.mainloop()
