import tkinter as tk
import ttkbootstrap as ttk
from ttkbootstrap.constants import *
from tkinter import messagebox
from bitarray import bitarray
import serial

# Configura a conexão serial (ajuste a porta COM e a taxa de baud conforme necessário)
try:
    ser = serial.Serial(port='COM9', baudrate=115200, bytesize=serial.EIGHTBITS)  # Substitua 'COM8' pela porta correta
    serial_status = True
except serial.SerialException:
    serial_status = False

# Função para enviar dados serialmente
def enviar_serial():
    tipo_obj = tipo_obj_entry.get()
    destino_obj = destino_obj_entry.get()
    origem_obj = origem_obj_entry.get()
    
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
    
    # Conversão para binário e montagem dos 6 bits de dados
    tipo_obj_bits = f"{int(tipo_obj):02b}"         # 2 bits para tipo_obj
    destino_obj_bits = f"{int(destino_obj):02b}"    # 2 bits para destino_obj
    origem_obj_bits = f"{int(origem_obj):02b}"      # 2 bits para origem_obj
    
    # Montagem do byte de dados: 2 bits não usados + 2 bits tipo_obj + 2 bits destino_obj + 2 bits origem_obj
    dados_bin = f"00{tipo_obj_bits}{destino_obj_bits}{origem_obj_bits}"
    
    # Envia dados se a conexão serial estiver ativa
    if serial_status:
        # dados_byte = int(dados_bin, 2).to_bytes(1, byteorder='big')
        dados_byte = bitarray(dados_bin).tobytes()
        ser.write(dados_byte)
        resposta_label.config(text=f"Dado enviado: {dados_bin} (binário).", bootstyle="success")
        messagebox.showinfo("Envio Bem-sucedido", f"Dado enviado: {dados_byte} (binário)")
    else:
        resposta_label.config(text="Erro: Conexão serial não estabelecida.", bootstyle="danger")
        messagebox.showerror("Erro de Conexão", "A conexão serial não está ativa.")

# Função para criar tooltip personalizado
def create_tooltip(widget, text):
    tooltip = tk.Toplevel(widget)
    tooltip.wm_overrideredirect(True)  # Remove barra de título
    tooltip.wm_geometry("+0+0")  # Posição inicial fora da tela

    label = ttk.Label(tooltip, text=text, bootstyle="light", padding=5)
    label.pack()

    def on_enter(event):
        x, y, _, _ = widget.bbox("insert")
        x += widget.winfo_rootx() + 20
        y += widget.winfo_rooty() + 20
        tooltip.wm_geometry(f"+{x}+{y}")
        tooltip.deiconify()

    def on_leave(event):
        tooltip.withdraw()

    widget.bind("<Enter>", on_enter)
    widget.bind("<Leave>", on_leave)
    tooltip.withdraw()  # Inicialmente invisível

# Configuração principal da interface com ttkbootstrap
janela = ttk.Window(themename="minty")  # Tema moderno e profissional
janela.title("Envio de Dados Serial")
janela.geometry("450x400")

# Título principal
titulo_label = ttk.Label(janela, text="Interface Serial - Envio para rx_serial_8N1", font=("Helvetica", 16, "bold"))
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

# Botão de envio com estilo e efeito 3D
enviar_button = ttk.Button(janela, text="Enviar Dados", command=enviar_serial, bootstyle="primary outline", width=20)
enviar_button.pack(pady=20)

# Exibição de resposta com sequência de bits enviada
resposta_label = ttk.Label(janela, text="", font=("Helvetica", 12))
resposta_label.pack(pady=10)

# Adiciona tooltips personalizadas para instruções extras ao usuário
create_tooltip(enviar_button, "Clique para enviar os dados para o receptor serial.")
create_tooltip(tipo_obj_entry, "Insira um valor entre 1 e 3 para o tipo do objeto.")
create_tooltip(destino_obj_entry, "Insira um valor entre 0 e 3 para o destino do objeto.")
create_tooltip(origem_obj_entry, "Insira um valor entre 0 e 3 para a origem do objeto.")

janela.mainloop()
