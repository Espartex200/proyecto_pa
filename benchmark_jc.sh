#!/bin/bash
# Script: benchmark.sh (MODO TOTAL: 4 HEURÍSTICAS)

# --- CONFIGURACIÓN ---
FD_PATH="python3 /home/juanc/fast-downward/fast-downward.py"
# IMPORTANTE: Subimos a 30s porque el doc dice que IPDB tarda en "pre-calcular" 
TIMEOUT_VAL="30s"

# Archivo de salida
OUT="benchmark_total.csv"
echo "Problema,Dificultad,Planificador,Modelo,Heuristica,Tiempo,Pasos,Nodos,Estado" > $OUT

echo "=========================================================="
echo "   BENCHMARK TOTAL (ULTIMATE EDITION)"
echo "   - 2 Modelos: Tile vs Blank"
echo "   - 4 Heurísticas: Blind, FF, LMCut, IPDB"
echo "=========================================================="

# Bucle de Problemas
for prob in "Modelo B/problems/"*.pddl; do
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
            domain="Modelo B/domain.pddl"
        fi

        # --- BUCLE DE HEURÍSTICAS ---
        # Añadimos IPDB (Pattern Databases) como sugiere el documento 
        for heur_name in "Blind" "FF" "LMCut" "IPDB"; do
            
            # Configurar búsqueda
            if [ "$heur_name" == "Blind" ]; then
                search_conf="astar(blind())"
            elif [ "$heur_name" == "FF" ]; then
                search_conf="lazy_greedy([ff()])"
            elif [ "$heur_name" == "LMCut" ]; then
                search_conf="astar(lmcut())"
            elif [ "$heur_name" == "IPDB" ]; then
                # Esta es la específica para puzzles
                search_conf="astar(ipdb())"
            fi

            echo "    Running: $model + $heur_name..."

            # EJECUCIÓN
            out=$(timeout $TIMEOUT_VAL $FD_PATH "$domain" "$prob" --search "$search_conf" 2>&1)

            # PARSEO
            time=$(echo "$out" | grep "Search time" | awk '{print $6}' | tr -d 's')
            steps=$(echo "$out" | grep "Plan length" | awk '{print $6}')
            nodes=$(echo "$out" | grep "Expanded" | awk '{print $5}')

            if [[ "$out" == *"Solution found"* ]]; then 
                state="OK"
            else 
                state="TIMEOUT"
                # Valores por defecto para que la gráfica no quede vacía
                time="30"
                steps="-"
                nodes="-"
            fi

            echo "$prob_name,$diff,FastDownward,$model,$heur_name,$time,$steps,$nodes,$state" >> $OUT

        done
    done
done

echo ""
echo "✅ ¡BENCHMARK TERMINADO! Revisa $OUT"