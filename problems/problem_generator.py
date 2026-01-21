import sys
import random

def generate_grid_graph(size):
    """Genera todas las adyacencias bidireccionales para una cuadrícula NxN."""
    adjacencies = []
    positions = []
    
    for r in range(1, size + 1):
        for c in range(1, size + 1):
            pos_name = f"pos-{r}-{c}"
            positions.append(pos_name)
            
            # Conexión Horizontal (Derecha)
            if c < size:
                neighbor = f"pos-{r}-{c+1}"
                adjacencies.append(f"(adjacent {pos_name} {neighbor})")
                adjacencies.append(f"(adjacent {neighbor} {pos_name})")
            
            # Conexión Vertical (Abajo)
            if r < size:
                neighbor = f"pos-{r+1}-{c}"
                adjacencies.append(f"(adjacent {pos_name} {neighbor})")
                adjacencies.append(f"(adjacent {neighbor} {pos_name})")
                
    return positions, adjacencies

def get_neighbors(r, c, size):
    """Devuelve las coordenadas válidas adyacentes a (r, c)."""
    moves = []
    if r > 1: moves.append((r-1, c)) # Arriba
    if r < size: moves.append((r+1, c)) # Abajo
    if c > 1: moves.append((r, c-1)) # Izquierda
    if c < size: moves.append((r, c+1)) # Derecha
    return moves

def generate_problem(size, steps, filename="problem.pddl"):
    # 1. Crear el estado SOLUCIONADO primero (Goal)
    # Representamos el tablero como una matriz para mover las piezas
    board = [[None for _ in range(size)] for _ in range(size)]
    tiles = []
    
    # Llenar el tablero ordenado
    tile_count = 1
    for r in range(size):
        for c in range(size):
            if r == size-1 and c == size-1:
                board[r][c] = "blank" # El último es el hueco
            else:
                t_name = f"t{tile_count}"
                board[r][c] = t_name
                tiles.append(t_name)
                tile_count += 1

    # Guardamos el estado meta para escribirlo luego en el :goal
    goal_lines = []
    for r in range(size):
        for c in range(size):
            pos = f"pos-{r+1}-{c+1}"
            if board[r][c] == "blank":
                goal_lines.append(f"(blank {pos})")
            else:
                goal_lines.append(f"(at {board[r][c]} {pos})")

    # 2. Desordenar (Random Walk)
    # Empezamos con el hueco en la esquina inferior derecha
    blank_r, blank_c = size-1, size-1
    
    # Hacemos movimientos aleatorios válidos hacia atrás
    for _ in range(steps):
        neighbors = get_neighbors(blank_r + 1, blank_c + 1, size)
        # Elegir un vecino al azar
        next_r, next_c = random.choice(neighbors)
        # Ajustar indices (de 1-based a 0-based)
        next_r -= 1
        next_c -= 1
        
        # Intercambiar hueco con ficha
        board[blank_r][blank_c] = board[next_r][next_c]
        board[next_r][next_c] = "blank"
        
        # Actualizar posición del hueco
        blank_r, blank_c = next_r, next_c

    # 3. Generar Strings PDDL
    positions, adj_lines = generate_grid_graph(size)
    
    init_lines = []
    init_lines.extend(adj_lines) # Añadir adyacencias al init
    
    # Añadir estado actual de las fichas al init
    for r in range(size):
        for c in range(size):
            pos = f"pos-{r+1}-{c+1}"
            val = board[r][c]
            if val == "blank":
                init_lines.append(f"(blank {pos})")
            else:
                init_lines.append(f"(at {val} {pos})")

    # 4. Escribir archivo
    with open(filename, "w") as f:
        f.write(f"(define (problem n-puzzle-{size}x{size})\n")
        f.write("  (:domain n-puzzle)\n")
        f.write("  (:objects\n")
        f.write(f"    {' '.join(tiles)} - tile\n")
        f.write(f"    {' '.join(positions)} - position\n")
        f.write("  )\n\n")
        
        f.write("  (:init\n")
        for line in init_lines:
            f.write(f"    {line}\n")
        f.write("  )\n\n")
        
        f.write("  (:goal (and\n")
        for line in goal_lines:
            f.write(f"    {line}\n")
        f.write("  ))\n")
        f.write(")\n")

    print(f"Archivo '{filename}' generado con éxito.")
    print(f"Tablero {size}x{size} desordenado con {steps} movimientos aleatorios.")

if __name__ == "__main__":
    # Configuración por defecto
    SIZE = 3      # 3x3 (8-puzzle)
    STEPS = 20    # Cantidad de movimientos para desordenar (Dificultad)
    OUTPUT = "problem.pddl"

    if len(sys.argv) > 1:
        SIZE = int(sys.argv[1])
    if len(sys.argv) > 2:
        STEPS = int(sys.argv[2])
    if len(sys.argv) > 3:
        OUTPUT = sys.argv[3]
        
    generate_problem(SIZE, STEPS, OUTPUT)