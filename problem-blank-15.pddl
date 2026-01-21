(define (problem puzzle-15-blank-hard)
  (:domain n-puzzle-blank)
  (:objects
    p1-1 p1-2 p1-3 p1-4
    p2-1 p2-2 p2-3 p2-4
    p3-1 p3-2 p3-3 p3-4
    p4-1 p4-2 p4-3 p4-4 - position
    t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 - tile
  )
  (:init
    ; --- MAPA DE ADYACENCIAS 4x4 ---
    (adjacent p1-1 p1-2) (adjacent p1-2 p1-1) (adjacent p1-2 p1-3) (adjacent p1-3 p1-2) (adjacent p1-3 p1-4) (adjacent p1-4 p1-3)
    (adjacent p2-1 p2-2) (adjacent p2-2 p2-1) (adjacent p2-2 p2-3) (adjacent p2-3 p2-2) (adjacent p2-3 p2-4) (adjacent p2-4 p2-3)
    (adjacent p3-1 p3-2) (adjacent p3-2 p3-1) (adjacent p3-2 p3-3) (adjacent p3-3 p3-2) (adjacent p3-3 p3-4) (adjacent p3-4 p3-3)
    (adjacent p4-1 p4-2) (adjacent p4-2 p4-1) (adjacent p4-2 p4-3) (adjacent p4-3 p4-2) (adjacent p4-3 p4-4) (adjacent p4-4 p4-3)
    (adjacent p1-1 p2-1) (adjacent p2-1 p1-1) (adjacent p2-1 p3-1) (adjacent p3-1 p2-1) (adjacent p3-1 p4-1) (adjacent p4-1 p3-1)
    (adjacent p1-2 p2-2) (adjacent p2-2 p1-2) (adjacent p2-2 p3-2) (adjacent p3-2 p2-2) (adjacent p3-2 p4-2) (adjacent p4-2 p3-2)
    (adjacent p1-3 p2-3) (adjacent p2-3 p1-3) (adjacent p2-3 p3-3) (adjacent p3-3 p2-3) (adjacent p3-3 p4-3) (adjacent p4-3 p3-3)
    (adjacent p1-4 p2-4) (adjacent p2-4 p1-4) (adjacent p2-4 p3-4) (adjacent p3-4 p2-4) (adjacent p3-4 p4-4) (adjacent p4-4 p3-4)

    ; --- ESTADO INICIAL (SOLUBLE - HARDCORE) ---
    ; Inverso total pero con 1 y 2 cambiados. Usando blank-at.
    (at t15 p1-1) (at t14 p1-2) (at t13 p1-3) (at t12 p1-4)
    (at t11 p2-1) (at t10 p2-2) (at t9 p2-3)  (at t8 p2-4)
    (at t7 p3-1)  (at t6 p3-2)  (at t5 p3-3)  (at t4 p3-4)
    (at t3 p4-1)  (at t1 p4-2)  (at t2 p4-3)  (blank-at p4-4)
  )
  (:goal (and
    ; OBJETIVO: 1 2 3 ... 15 _
    (at t1 p1-1) (at t2 p1-2) (at t3 p1-3) (at t4 p1-4)
    (at t5 p2-1) (at t6 p2-2) (at t7 p2-3) (at t8 p2-4)
    (at t9 p3-1) (at t10 p3-2) (at t11 p3-3) (at t12 p3-4)
    (at t13 p4-1) (at t14 p4-2) (at t15 p4-3) (blank-at p4-4)
  ))
)
