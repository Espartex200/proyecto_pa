(define (domain n-puzzle)
  (:requirements :strips :typing)
  (:types position tile)

  (:predicates
    (at ?t - tile ?p - position)   
    (blank ?p - position)          
    (adjacent ?p1 ?p2 - position)  
  )

  (:action move-tile
    :parameters (?t - tile ?from - position ?to - position)
    :precondition (and 
        (at ?t ?from)
        (blank ?to)
        (adjacent ?from ?to)
    )
    :effect (and 
        (not (at ?t ?from))
        (not (blank ?to))
        (at ?t ?to)
        (blank ?from)
    )
  )
)
