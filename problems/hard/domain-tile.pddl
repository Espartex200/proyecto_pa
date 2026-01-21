(define (domain n-puzzle-tile)
  (:requirements :strips :typing)
  (:types position tile)

  (:predicates
    (at ?t - tile ?p - position)   
    (empty ?p - position)          
    (adjacent ?p1 ?p2 - position)  
  )

  (:action move-tile
    :parameters (?t - tile ?from - position ?to - position)
    :precondition (and 
        (at ?t ?from)
        (empty ?to)
        (adjacent ?from ?to)
    )
    :effect (and 
        (not (at ?t ?from))
        (not (empty ?to))
        (at ?t ?to)
        (empty ?from)
    )
  )
)
