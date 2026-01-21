(define (problem puzzle-tile-hard)
  (:domain n-puzzle-tile)
  (:objects
    p1-1 p1-2 p1-3
    p2-1 p2-2 p2-3
    p3-1 p3-2 p3-3 - position
    t1 t2 t3 t4 t5 t6 t7 t8 - tile
  )
  (:init
    ; Mapa 3x3
    (adjacent p1-1 p1-2) (adjacent p1-2 p1-1) (adjacent p1-2 p1-3) (adjacent p1-3 p1-2)
    (adjacent p2-1 p2-2) (adjacent p2-2 p2-1) (adjacent p2-2 p2-3) (adjacent p2-3 p2-2)
    (adjacent p3-1 p3-2) (adjacent p3-2 p3-1) (adjacent p3-2 p3-3) (adjacent p3-3 p3-2)
    (adjacent p1-1 p2-1) (adjacent p2-1 p1-1) (adjacent p2-1 p3-1) (adjacent p3-1 p2-1)
    (adjacent p1-2 p2-2) (adjacent p2-2 p1-2) (adjacent p2-2 p3-2) (adjacent p3-2 p2-2)
    (adjacent p1-3 p2-3) (adjacent p2-3 p1-3) (adjacent p2-3 p3-3) (adjacent p3-3 p2-3)

    ; ESTADO INICIAL DIFÍCIL (SOLUBLE)
    ; 8 6 7
    ; 2 5 4
    ; 3 _ 1
    (at t8 p1-1) (at t6 p1-2) (at t7 p1-3)
    (at t2 p2-1) (at t5 p2-2) (at t4 p2-3)
    (at t3 p3-1) (empty p3-2) (at t1 p3-3)
  )
  (:goal (and
    ; 1 2 3
    ; 4 5 6
    ; 7 8 _
    (at t1 p1-1) (at t2 p1-2) (at t3 p1-3)
    (at t4 p2-1) (at t5 p2-2) (at t6 p2-3)
    (at t7 p3-1) (at t8 p3-2) (empty p3-3)
  ))
)
