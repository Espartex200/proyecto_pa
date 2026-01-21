#!/bin/bash
 --- CARGA DE CONFIGURACIÓN LOCAL ---
if [ -f "config.env" ]; then
    source config.env
    echo "Configuración cargada desde config.env"
else
    echo "ADVERTENCIA: No se encontró config.env. Usando valores por defecto."
    FD_PATH="python3 /home/juanc/fast-downward/fast-downward.py"
    UCPOP_CMD="/home/juanc/ucpop/ucpop" 
fi

# --- CARGA DE CONFIGURACIÓN GENERAL ---
TIMEOUT=60
PROBLEMS_FOLDER="problems/hard"


# Configuración
TIMEOUT=60
LOG_DIR="results/logs_hard_full"

# Asegurar que el dominio entiende a los problemas
sed -i 's/blank/empty/g' domain-tile.pddl 2>/dev/null

mkdir -p "$LOG_DIR"
echo ">>> Limpiando logs antiguos..."
rm -f "$LOG_DIR"/*.txt

# Función de ejecución
run_ex() {
    local size=$1      # 8, 12, 15
    local model=$2     # tile, blank
    local heur_name=$3 # Blind, FF, LMCut, IPDB
    local heur_cmd=$4  # astar(blind()), etc.
    local domain="problems/hard/domain-${model}.pddl"
    
    # Seleccionar el problema correcto según tamaño y modelo
    if [ "$size" == "8" ]; then prob="${PROBLEMS_FOLDER}/problem-${model}-hard.pddl"; fi
    if [ "$size" == "12" ]; then prob="${PROBLEMS_FOLDER}/problem-${model}-12.pddl"; fi
    if [ "$size" == "15" ]; then prob="${PROBLEMS_FOLDER}/problem-${model}-15.pddl"; fi

    local logfile="$LOG_DIR/log_${size}_${model}_${heur_name}.txt"

    echo "[EJECUTANDO] ${size}-Puzzle (${model}) con ${heur_name}..."
    
    timeout $TIMEOUT bash -c "$FD_PATH '$domain' '$prob' --search '$heur_cmd'" > "$logfile" 2>&1
    
    # Si fue timeout, lo marcamos en el log
    if [ $? -eq 124 ]; then echo "TIMEOUT_MARKER" >> "$logfile"; fi
}

echo "==========================="
echo "  BENCHMARK TOTAL (HARD)"
echo "==========================="

# Arrays de configuración
MODELS=("tile" "blank")
HEUR_NAMES=("Blind" "FF" "LMCut" "IPDB")
HEUR_CMDS=("astar(blind())" "lazy_greedy([ff()])" "astar(lmcut())" "astar(ipdb())")

# BUCLE TRIPLE MORTAL
for size in 8 12 15; do
    for model in "${MODELS[@]}"; do
        for i in {0..3}; do
            run_ex "$size" "$model" "${HEUR_NAMES[$i]}" "${HEUR_CMDS[$i]}"
        done
    done
done

echo ""
python3 ./problems/hard/generate_table.py