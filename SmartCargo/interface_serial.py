import tkinter as tk
from tkinter import messagebox
import ttkbootstrap as ttk
from ttkbootstrap.constants import *
import serial

# Configura a conexão serial
try:
    ser = serial.Serial(port='COM19', baudrate=115200, bytesize=serial.EIGHTBITS, timeout=1)
    serial_status = True
except serial.SerialException:
    ser = None
    serial_status = False

# Função para enviar mensagens específicas de Reset e Emergência
def enviar_mensagem(mensagem_bin):
    if serial_status:
        ser.write(int(mensagem_bin, 2).to_bytes(1, byteorder="big"))
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
    if not (1 <= int(destino_obj) <= 4 and 1 <= int(origem_obj) <= 4):
        messagebox.showerror("Erro de Origem e Destino", "Origem e Destino devem estar entre 1 e 4.")
        return

    # Montagem do byte de dados
    tipo_obj_bits = f"{int(tipo_obj):02b}"
    destino_obj_bits = f"{int(destino_obj) - 1:02b}"  # Subtração para converter de 1-4 para 0-3
    origem_obj_bits = f"{int(origem_obj) - 1:02b}"   # Subtração para converter de 1-4 para 0-3
    reset_bit = f"{reset_state:01b}"
    emergencia_bit = f"{emergencia_state:01b}"
    dados_bin = f"{emergencia_bit}{reset_bit}{tipo_obj_bits}{destino_obj_bits}{origem_obj_bits}"

    # Envia os dados
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
janela.title("Interface Serial para Transmissão")
janela.geometry("500x500")

# Indicador de conexão serial
status_label = ttk.Label(janela, text="Conexão Serial Ativa" if serial_status else "Conexão Serial Inativa", 
                         bootstyle="success" if serial_status else "danger")
status_label.pack(pady=5)

# Entradas de Tipo, Origem e Destino com rótulos apropriados
frame_inputs = ttk.Frame(janela)
frame_inputs.pack(pady=10)

ttk.Label(frame_inputs, text="Tipo do Objeto (1 a 3):", font=("Helvetica", 12)).grid(row=0, column=0, padx=5, pady=5, sticky="w")
tipo_obj_entry = ttk.Entry(frame_inputs, width=10)
tipo_obj_entry.grid(row=0, column=1, padx=5, pady=5)
tipo_obj_entry.insert(0, "1")

ttk.Label(frame_inputs, text="Origem (1 a 4):", font=("Helvetica", 12)).grid(row=1, column=0, padx=5, pady=5, sticky="w")
origem_obj_entry = ttk.Entry(frame_inputs, width=10)
origem_obj_entry.grid(row=1, column=1, padx=5, pady=5)
origem_obj_entry.insert(0, "1")

ttk.Label(frame_inputs, text="Destino (1 a 4):", font=("Helvetica", 12)).grid(row=2, column=0, padx=5, pady=5, sticky="w")
destino_obj_entry = ttk.Entry(frame_inputs, width=10)
destino_obj_entry.grid(row=2, column=1, padx=5, pady=5)
destino_obj_entry.insert(0, "1")

# Botão para enviar dados
ttk.Button(janela, text="Enviar Dados", command=enviar_serial).pack(pady=10)

# Toggle para Reset
reset_var = tk.IntVar(value=0)
reset_toggle = ttk.Checkbutton(janela, text="Reset", variable=reset_var, bootstyle="switch", command=toggle_reset)
reset_toggle.pack(pady=10)

# Toggle para Emergência
emergencia_var = tk.IntVar(value=0)
emergencia_toggle = ttk.Checkbutton(janela, text="Emergência", variable=emergencia_var, bootstyle="switch", command=toggle_emergencia)
emergencia_toggle.pack(pady=10)

# Exibição de resposta
resposta_label = ttk.Label(janela, text="", font=("Helvetica", 12))
resposta_label.pack(pady=10)

janela.mainloop()