# N-PUZZLE PLANNER

## MODELO B
Modelado del problema del N-Puzle enfocado a mover el espacio en blanco. 

Para generar un problema utilizar el script de python `problem_generator.py`. Se puede modificar el tamaño, número de pasos y nombre del archivo. Por ejemplo, un problema de 3x3, 20 pasos llamado "problem1.pddl" se crea usando:
```bash
python3 problem_generator.py 3 20 "problem1.pddl"
```

Utilizando el archivo `generar_todos_problemas.sh` se generan 21 problemas, 3 problemas para cada 3 tamaños y 3 dificultades diferentes.