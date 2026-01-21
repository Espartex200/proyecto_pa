import os
import re
import csv

LOG_DIR = "results/logs_hard_full"
CSV_FILE = "results/benchmark_hard_completo.csv"

# Regex para extraer datos
REGEX_TIME = re.compile(r"(?:Planner|Search) time:\s*([\d\.]+)")
REGEX_STEPS = re.compile(r"(?:Plan length|Plan cost).*?(\d+)")
REGEX_NODES = re.compile(r"Expanded\s+(\d+)\s+state")  # <--- CAPTURA NODOS
REGEX_TIMEOUT = re.compile(r"TIMEOUT_MARKER|TIMEOUT")
REGEX_SUCCESS = re.compile(r"search exit code: 0")

print(f"{'PROBLEMA':<25} | {'MOD':<5} | {'HEUR':<6} | {'TIME':<8} | {'PASOS':<6} | {'NODOS':<8} | {'EST'}")
print("-" * 90)

data_rows = []

# Ordenar archivos para que salgan bonitos (8, then 12, then 15)
def sort_key(fname):
    # Truco para ordenar: 8, 12, 15
    parts = fname.split('_')
    size = int(parts[1])
    return size

files = [f for f in os.listdir(LOG_DIR) if f.endswith(".txt")]
files.sort(key=sort_key)

for filename in files:
    # Nombre esperado: log_8_tile_FF.txt
    parts = filename.replace(".txt", "").split("_")
    size = parts[1]      # 8
    model = parts[2]     # tile
    heur = parts[3]      # FF

    # Mapear nombre del problema real para el CSV
    if size == "8":
        prob_name = f"problem_{model}_hard.pddl"
        diff = "Hard (3x3)"
    elif size == "12":
        prob_name = f"problem_{model}_12.pddl"
        diff = "Hard (3x4)"
    else:
        prob_name = f"problem_{model}_15.pddl"
        diff = "Hard (4x4)"

    # Leer Log
    path = os.path.join(LOG_DIR, filename)
    with open(path, "r", errors="ignore") as f:
        content = f.read()

    # Extraer Datos
    time = "-"
    steps = "-"
    nodes = "-"
    state = "ERROR"

    if REGEX_TIMEOUT.search(content):
        state = "TIMEOUT"
        time = "> 60s"
    elif REGEX_SUCCESS.search(content) or "Solution found" in content:
        state = "OK"
        
        # Tiempo
        m_time = REGEX_TIME.search(content)
        if m_time: time = m_time.group(1)

        # Pasos
        m_steps = REGEX_STEPS.search(content)
        if m_steps: steps = m_steps.group(1)

        # Nodos
        m_nodes = REGEX_NODES.search(content)
        if m_nodes: nodes = m_nodes.group(1)

    # Imprimir en consola
    print(f"{prob_name:<25} | {model:<5} | {heur:<6} | {time:<8} | {steps:<6} | {nodes:<8} | {state}")

    # Guardar fila para CSV (Formato solicitado)
    # Problema,Dificultad,Planificador,Modelo,Heuristica,Tiempo,Pasos,Nodos,Estado
    row = [
        prob_name,
        diff,
        "FastDownward",
        model.capitalize(), # Tile/Blank
        heur,
        time,
        steps,
        nodes,
        state
    ]
    data_rows.append(row)

# Escribir CSV
with open(CSV_FILE, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["Problema", "Dificultad", "Planificador", "Modelo", "Heuristica", "Tiempo", "Pasos", "Nodos", "Estado"])
    writer.writerows(data_rows)

print("-" * 90)
print(f"CSV Generado: {CSV_FILE}")
