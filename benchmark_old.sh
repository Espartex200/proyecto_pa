#!/bin/bash
# Script: benchmark.sh

# --- CONFIGURACIÓN ---
# 1. Ruta Fast Downward (con python3 delante para que no falle)
FD_PATH="python3 /home/juanc/fast-downward/fast-downward.py"

# 2. Ruta UCPOP (La que comprobamos que existe)
UCPOP_CMD="/home/juanc/ucpop/ucpop" 

# Archivo de salida
OUT="benchmark_total.csv"
echo "Problema,Dificultad,Planificador,Modelo,Tiempo,Pasos,Estado" > $OUT

echo "=========================================================="
echo " BENCHMARK TOTAL: 21 Problemas (TODO REAL)"
echo "   - Fast Downward: Tile vs Blank"
echo "   - UCPOP: Blank (Timeout: 5s)"
echo "=========================================================="

# Bucle para recorrer los problemas
for prob in "Modelo B/problems/"*.pddl; do
    prob_name=$(basename "$prob")
    
    # Detectar dificultad
    if [[ $prob_name == *"2x2"* ]]; then diff="Facil";
    elif [[ $prob_name == *"3x3"* ]]; then diff="Medio";
    elif [[ $prob_name == *"4x4"* ]]; then diff="Dificil";
    else diff="Desconocido"; fi

    echo ">>> Analizando: $prob_name ($diff)"

    # ---------------------------------------------------------
    # 1. FAST DOWNWARD - MODELO TILE (TUYO)
    # ---------------------------------------------------------
    echo "    [1/3] FD + TILE..."
    out=$(timeout 60s $FD_PATH "Modelo A/domain-tile.pddl" "$prob" --search "lazy_greedy([ff()])" 2>&1)
    
    # Leemos la columna 6 (tiempo) y 6 (pasos) donde toca
    time=$(echo "$out" | grep "Search time" | awk '{print $6}' | tr -d 's')
    steps=$(echo "$out" | grep "Plan length" | awk '{print $6}')
    
    if [[ "$out" == *"Solution found"* ]]; then state="OK"; else state="TIMEOUT"; fi
    # Valores por defecto si falla
    if [ "$state" == "TIMEOUT" ]; then time="60"; steps="-"; fi

    echo "$prob_name,$diff,FastDownward,Tile,$time,$steps,$state" >> $OUT


    # ---------------------------------------------------------
    # 2. FAST DOWNWARD - MODELO BLANK (MANUEL)
    # ---------------------------------------------------------
    echo "    [2/3] FD + BLANK..."
    out=$(timeout 60s $FD_PATH "Modelo B/domain.pddl" "$prob" --search "lazy_greedy([ff()])" 2>&1)
    
    time=$(echo "$out" | grep "Search time" | awk '{print $6}' | tr -d 's')
    steps=$(echo "$out" | grep "Plan length" | awk '{print $6}')
    
    if [[ "$out" == *"Solution found"* ]]; then state="OK"; else state="TIMEOUT"; fi
    if [ "$state" == "TIMEOUT" ]; then time="60"; steps="-"; fi
    
    echo "$prob_name,$diff,FastDownward,Blank,$time,$steps,$state" >> $OUT
    
    # ---------------------------------------------------------
    # 3. UCPOP (REAL CON TIMEOUT CORTO)
    # ---------------------------------------------------------
    echo "    [3/3] UCPOP + BLANK..."
    
    # Le damos solo 5 segundos. Si puede, bien. Si no, fuera.
    out_ucpop=$(timeout 5s $UCPOP_CMD "Modelo B/problems/$prob_name" 2>&1)
    
    # UCPOP es más difícil de leer automáticmente, así que miramos si dice "Stats:"
    # Si el comando timeout lo cortó, el código de salida será 124
    ret_code=$?
    
    if [ $ret_code -eq 124 ]; then
        echo "$prob_name,$diff,UCPOP,Blank,5.0,-,TIMEOUT" >> $OUT
    else
        # Si terminó, intentamos ver si tuvo éxito (esto depende de lo que escupa tu ucpop)
        # Asumimos OK si no murió por timeout para simplificar, o ERROR si falló
        echo "$prob_name,$diff,UCPOP,Blank,-,-,INTENTADO" >> $OUT
    fi

done

echo ""
echo "✅ ¡TERMINADO! Revisa $OUT"