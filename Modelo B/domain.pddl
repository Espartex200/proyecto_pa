(define (domain n-puzzle)
  (:requirements :strips :typing)
  (:types tile position - object)

  (:predicates
    (at ?t - tile ?p - position)
    (blank ?p - position)
    (adjacent ?p1 ?p2 - position)
  )

  (:action slide-blank
    :parameters (?from - position  ; Donde esta el hueco AHORA
                 ?to - position    ; A donde va el hueco (donde esta la ficha)
                 ?t - tile)        ; La ficha que vamos a "empujar"
                 
    :precondition (and 
        (blank ?from)       ; El origen DEBE ser el hueco
        (at ?t ?to)         ; En el destino DEBE haber una ficha
        (adjacent ?from ?to); Deben estar conectados
    )

    :effect (and 
        ; Mover el hueco
        (not (blank ?from))
        (blank ?to)

        ; Mover la ficha (efecto colateral del movimiento del hueco)
        (not (at ?t ?to))
        (at ?t ?from)
    )
  )
)