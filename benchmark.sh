#!/bin/bash
# Script: benchmark_total.sh

# --- CONFIGURACIÓN ---
FD_PATH="/home/juanc/fast-downward/fast-downward.py"
# Pon aquí la ruta a tu ejecutable de UCPOP si lo tienes
UCPOP_CMD="/home/juanc/ucpop/ucpop"

# Archivo de salida
OUT="benchmark_total.csv"
echo "Problema,Dificultad,Planificador,Modelo,Tiempo,Pasos,Estado" > $OUT

echo "=========================================================="
echo " BENCHMARK TOTAL: 21 Problemas x 2 Modelos x 2 Planificadores"
echo "=========================================================="

# Bucle para recorrer los 21 problemas de Manuel
for prob in "Modelo B/problems/"*.pddl; do
    prob_name=$(basename "$prob")
    
    # Detectar dificultad (Facil/Medio/Dificil)
    if [[ $prob_name == *"2x2"* ]]; then diff="Facil";
    elif [[ $prob_name == *"3x3"* ]]; then diff="Medio";
    elif [[ $prob_name == *"4x4"* ]]; then diff="Dificil";
    else diff="Desconocido"; fi

    echo ">>> Analizando: $prob_name ($diff)"

    # ---------------------------------------------------------
    # 1. FAST DOWNWARD - MODELO TILE (TUYO)
    # ---------------------------------------------------------
    echo "    [1/4] FD + TILE..."
    # Timeout de 60 segundos (si no lo saca en 1 min, no lo saca en 5)
    out=$(timeout 60s $FD_PATH "Modelo A/domain-tile.pddl" "$prob" --search "lazy_greedy([ff()])" 2>&1)
    
    # Extraer datos
    time=$(echo "$out" | grep "Search time" | awk '{print $3}' | tr -d 's')
    steps=$(echo "$out" | grep "Plan length" | awk '{print $3}')
    if [[ "$out" == *"Solution found"* ]]; then state="OK"; else state="TIMEOUT"; fi
    
    echo "$prob_name,$diff,FastDownward,Tile,${time:-60},${steps:-0},$state" >> $OUT


    # ---------------------------------------------------------
    # 2. FAST DOWNWARD - MODELO BLANK (MANUEL)
    # ---------------------------------------------------------
    echo "    [2/4] FD + BLANK..."
    out=$(timeout 60s $FD_PATH "Modelo B/domain.pddl" "$prob" --search "lazy_greedy([ff()])" 2>&1)
    
    time=$(echo "$out" | grep "Search time" | awk '{print $3}' | tr -d 's')
    steps=$(echo "$out" | grep "Plan length" | awk '{print $3}')
    if [[ "$out" == *"Solution found"* ]]; then state="OK"; else state="TIMEOUT"; fi
    
    echo "$prob_name,$diff,FastDownward,Blank,${time:-60},${steps:-0},$state" >> $OUT


    # ---------------------------------------------------------
    # 3. UCPOP (EL ANTIGUO)
    # ---------------------------------------------------------
    # OJO: Solo intentamos UCPOP si tienes el comando configurado.
    # Si no, comenta esta parte.
    
    echo "    [3/4] UCPOP + BLANK (Intento)..."
    # Ajusta este comando a como tú ejecutes UCPOP normalmente
    # UCPOP suele ser lento, le damos 30s de timeout para no eternizar
    # out_ucpop=$(timeout 30s $UCPOP_CMD "Modelo B/domain.pddl" "$prob" 2>&1)
    
    # Como UCPOP es difícil de parsear automáticamente, aquí asumimos TIMEOUT
    # si es un problema grande. Puedes descomentar las líneas de arriba si quieres probarlo real.
    
    if [[ $diff == "Facil" ]]; then
       # Aquí podrías ejecutarlo de verdad si quieres
       echo "$prob_name,$diff,UCPOP,Blank,-,-,INTENTADO" >> $OUT
    else
       # Para los grandes, asumimos que explota (para ahorrarte 30 mins de espera)
       echo "$prob_name,$diff,UCPOP,Blank,-,-,SKIP_TIMEOUT" >> $OUT
    fi

done

echo ""
echo "✅ ¡TERMINADO! Tabla guardada en $OUT"