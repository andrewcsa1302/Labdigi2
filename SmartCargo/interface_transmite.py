import tkinter as tk
from tkinter import messagebox
import ttkbootstrap as ttk
from ttkbootstrap.constants import *
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
mensagens_recebidas = [{"Tipo": "-", "Destino": "-"} for _ in range(8)]

# Função para escutar mensagens serial
def escutar_serial():
    global mensagens_recebidas
    while True:
        if serial_status:
            try:
                bloco_mensagens = []  # Armazena um bloco de 8 mensagens
                for i in range(7):
                    mensagem = ser.read(1)  # Lê 1 byte
                    if mensagem:
                        byte = bin(ord(mensagem))[2:].zfill(7)  # Converte para 7 bits
                        if byte[:3] == "111":  # Valida os 3 primeiros bits
                            tipo_obj = int(byte[3:5], 2)  # Decodifica tipo
                            destino_obj = int(byte[5:7], 2) + 1  # Incrementa para interface (andar 1 a 4)
                            bloco_mensagens.append({"Tipo": tipo_obj, "Destino": destino_obj})
                        else:
                            bloco_mensagens.append({"Tipo": "Inválido", "Destino": "Inválido"})
                    else:
                        bloco_mensagens.append({"Tipo": "Timeout", "Destino": "Timeout"})

                # Atualiza a lista de mensagens e a interface
                mensagens_recebidas = bloco_mensagens
                atualizar_interface()
            except Exception as e:
                print("Erro ao receber mensagem:", e)
        time.sleep(1)  # Aguarda para evitar alto uso da CPU

# Função para atualizar os dados na interface
def atualizar_interface():
    for i, msg in enumerate(mensagens_recebidas):
        tipo = msg["Tipo"]
        destino = msg["Destino"]
        mensagem_labels[i]["Tipo"].config(text=f"Tipo: {tipo}")
        mensagem_labels[i]["Destino"].config(text=f"Destino: {destino}")

# Inicia thread para escutar mensagens seriais
threading.Thread(target=escutar_serial, daemon=True).start()

# Configuração principal da interface com ttkbootstrap
janela = ttk.Window(themename="minty")  # Tema moderno e profissional
janela.title("Interface Serial para Recepção")
janela.geometry("500x700")

# Indicador de conexão serial
status_label = ttk.Label(janela, text="Conexão Serial Ativa" if serial_status else "Conexão Serial Inativa", 
                         bootstyle="success" if serial_status else "danger")
status_label.pack(pady=5)

# Exibição das mensagens recebidas
mensagens_frame = ttk.Frame(janela)
mensagens_frame.pack(pady=10)

mensagem_labels = []
for i in range(7):
    frame = ttk.Frame(mensagens_frame)
    frame.pack(pady=5)
    ttk.Label(frame, text=f"Mensagem {i + 1}:").grid(row=0, column=0, padx=5)
    tipo_label = ttk.Label(frame, text="Tipo: -", width=15)
    tipo_label.grid(row=0, column=1, padx=5)
    destino_label = ttk.Label(frame, text="Destino: -", width=15)
    destino_label.grid(row=0, column=2, padx=5)
    mensagem_labels.append({"Tipo": tipo_label, "Destino": destino_label})

# Exibição de logs de resposta
resposta_label = ttk.Label(janela, text="Recepção de mensagens aguardando...", font=("Helvetica", 12))
resposta_label.pack(pady=10)

janela.mainloop()