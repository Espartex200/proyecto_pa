(define (problem puzzle-12-tile-hard)
  (:domain n-puzzle-tile)
  (:objects
    p1-1 p1-2 p1-3 p1-4
    p2-1 p2-2 p2-3 p2-4
    p3-1 p3-2 p3-3 p3-4 - position
    t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 - tile
  )
  (:init
    ; --- MAPA DE ADYACENCIAS 3x4 ---
    ; Filas
    (adjacent p1-1 p1-2) (adjacent p1-2 p1-1) (adjacent p1-2 p1-3) (adjacent p1-3 p1-2) (adjacent p1-3 p1-4) (adjacent p1-4 p1-3)
    (adjacent p2-1 p2-2) (adjacent p2-2 p2-1) (adjacent p2-2 p2-3) (adjacent p2-3 p2-2) (adjacent p2-3 p2-4) (adjacent p2-4 p2-3)
    (adjacent p3-1 p3-2) (adjacent p3-2 p3-1) (adjacent p3-2 p3-3) (adjacent p3-3 p3-2) (adjacent p3-3 p3-4) (adjacent p3-4 p3-3)
    
    ; Columnas
    (adjacent p1-1 p2-1) (adjacent p2-1 p1-1) (adjacent p2-1 p3-1) (adjacent p3-1 p2-1)
    (adjacent p1-2 p2-2) (adjacent p2-2 p1-2) (adjacent p2-2 p3-2) (adjacent p3-2 p2-2)
    (adjacent p1-3 p2-3) (adjacent p2-3 p1-3) (adjacent p2-3 p3-3) (adjacent p3-3 p2-3)
    (adjacent p1-4 p2-4) (adjacent p2-4 p1-4) (adjacent p2-4 p3-4) (adjacent p3-4 p2-4)

    ; --- ESTADO INICIAL (DIFÍCIL PERO SOLUBLE) ---
    ; Configuración aleatorizada con paridad correcta
    (at t11 p1-1) (at t10 p1-2) (at t9 p1-3) (at t8 p1-4)
    (at t7 p2-1)  (at t6 p2-2)  (at t5 p2-3) (at t4 p2-4)
    (at t3 p3-1)  (at t1 p3-2)  (at t2 p3-3) (empty p3-4)
  )
  (:goal (and
    ; OBJETIVO: 1 2 3 4 / 5 6 7 8 / 9 10 11 _
    (at t1 p1-1) (at t2 p1-2) (at t3 p1-3) (at t4 p1-4)
    (at t5 p2-1) (at t6 p2-2) (at t7 p2-3) (at t8 p2-4)
    (at t9 p3-1) (at t10 p3-2) (at t11 p3-3) (empty p3-4)
  ))
)
