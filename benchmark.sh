
# --- CARGA DE CONFIGURACIÓN LOCAL ---
if [ -f "config.env" ]; then
    source config.env
    echo "Configuración cargada desde config.env"
else
    echo "ADVERTENCIA: No se encontró config.env. Usando valores por defecto."
    FD_PATH="python3 /home/juanc/fast-downward/fast-downward.py"
    UCPOP_CMD="/home/juanc/ucpop/ucpop" 
fi

# --- CARGA DE CONFIGURACIÓN GENERAL ---
TIMEOUT_VAL="30s"
OUT="results/benchmark.csv"
PROBLEMS_FOLDER="problems/normal"
rm -f "$OUT"

echo "Problema,Dificultad,Planificador,Modelo,Heuristica,Tiempo,Pasos,Nodos,Estado" > $OUT

echo "=========================================================="
echo "   BENCHMARK TOTAL"
echo "   - 2 Modelos: Tile vs Blank"
echo "   - 4 Heurísticas: Blind, FF, LMCut, IPDB"
echo "=========================================================="

# Bucle de Problemas
for prob in "$PROBLEMS_FOLDER"/*.pddl; do
    prob_name=$(basename "$prob")
    
    # Detectar dificultad
    if [[ $prob_name == *"2x2"* ]]; then diff="Facil";
    elif [[ $prob_name == *"3x3"* ]]; then diff="Medio";
    elif [[ $prob_name == *"4x4"* ]]; then diff="Dificil";
    else diff="Desconocido"; fi

    echo ">>> Procesando: $prob_name ($diff)"

    # --- BUCLE DE MODELOS ---
    for model in "Tile" "Blank"; do
        
        if [ "$model" == "Tile" ]; then
            domain="Modelo A/domain-tile.pddl"
        else
            domain="Modelo B/domain-blank.pddl"
        fi
        # --- BUCLE DE HEURÍSTICAS ---
        for heur_name in "Blind" "FF" "LMCut" "IPDB"; do
            
            # Configurar búsqueda
            if [ "$heur_name" == "Blind" ]; then
                search_conf="astar(blind())"
            elif [ "$heur_name" == "FF" ]; then
                search_conf="lazy_greedy([ff()])"
            elif [ "$heur_name" == "LMCut" ]; then
                search_conf="astar(lmcut())"
            elif [ "$heur_name" == "IPDB" ]; then
                search_conf="astar(ipdb())"
            fi

            echo "    Running: $model + $heur_name..."

            # EJECUCIÓN
            out=$(timeout $TIMEOUT_VAL $FD_PATH "$domain" "$prob" --search "$search_conf" 2>&1)

            # PARSEO
            time=$(echo "$out" | grep "Search time" | head -n 1 | awk '{print $6}' | tr -d 's\n\r')
            steps=$(echo "$out" | grep "Plan length" | head -n 1 | awk '{print $6}' | tr -d '\n\r')
            nodes=$(echo "$out" | grep "Expanded" | head -n 1 | awk '{print $5}' | tr -d '\n\r')

            if [[ "$out" == *"Solution found"* ]]; then 
                state="OK"
            else 
                state="TIMEOUT"
                time="30"
                steps="-"
                nodes="-"
            fi

            # ESCRITURA
            echo "$prob_name,$diff,FastDownward,$model,$heur_name,$time,$steps,$nodes,$state" >> $OUT

        done
    done
done

echo ""
echo "¡BENCHMARK TERMINADO! Revisa $OUT"