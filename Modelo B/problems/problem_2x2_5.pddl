(define (problem n-puzzle-2x2)
  (:domain n-puzzle)
  (:objects
    t1 t2 t3 - tile
    pos-1-1 pos-1-2 pos-2-1 pos-2-2 - position
  )

  (:init
    (adjacent pos-1-1 pos-1-2)
    (adjacent pos-1-2 pos-1-1)
    (adjacent pos-1-1 pos-2-1)
    (adjacent pos-2-1 pos-1-1)
    (adjacent pos-1-2 pos-2-2)
    (adjacent pos-2-2 pos-1-2)
    (adjacent pos-2-1 pos-2-2)
    (adjacent pos-2-2 pos-2-1)
    (at t3 pos-1-1)
    (at t1 pos-1-2)
    (blank pos-2-1)
    (at t2 pos-2-2)
  )

  (:goal (and
    (at t1 pos-1-1)
    (at t2 pos-1-2)
    (at t3 pos-2-1)
    (blank pos-2-2)
  ))
)
