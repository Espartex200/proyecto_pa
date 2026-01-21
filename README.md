# N-PUZZLE PLANNER

Proyecto para probar diferentes modelos y algoritmos para solucionar el n-puzle.

---

## 1. Comparar Modelos

Para comparar los modelos existen dos scripts distintos. Para ejecutarlos se recomienda crear un archivo config.env con el siguiente contenido:

```env
FD_PATH= "apptainer run ./fast-downward.sif" # O equivalente
UCPOP_CMD= # Ruta a UCPOP
```

---
Para poder ejecutar la comparación estándar utilizar
```bash
./benchmark.sh
```
Los resultados se guardan en el csv `results/benchmark.csv`

---
Para poder ejecutar la comparación de problemas más complicados utilizar
```bash
./benchmark_hard.sh
```
Los resultados se guardan en el csv `results/benchmark_hard_completo.csv`

---

## 2. Generar problemas

Para generar un problema utilizar el script de python `problem_generator.py`. Se puede modificar el tamaño, número de pasos y nombre del archivo. Por ejemplo, un problema de 3x3, 20 pasos llamado "problem1.pddl" se crea usando:
```bash
python3 problems/problem_generator.py 3 20 "problem1.pddl"
```

Utilizando el archivo `problems/generar_todos_problemas.sh` se generan 21 problemas, 3 problemas para cada 3 tamaños y 3 dificultades diferentes.

