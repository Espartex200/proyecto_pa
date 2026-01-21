(define (domain n-puzzle-blank)
  (:requirements :strips :typing)
  (:types position tile)

  (:predicates
    (at ?t - tile ?p - position)
    (blank-at ?p - position)      
    (adjacent ?p1 ?p2 - position)
  )

  (:action move-blank
    :parameters (?from - position ?to - position ?t - tile)
    :precondition (and 
        (blank-at ?from)
        (adjacent ?from ?to)
        (at ?t ?to) 
    )
    :effect (and 
        (not (blank-at ?from))
        (not (at ?t ?to))
        (blank-at ?to)
        (at ?t ?from) 
    )
  )
)
