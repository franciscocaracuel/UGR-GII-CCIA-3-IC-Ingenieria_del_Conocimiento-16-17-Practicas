(deftemplate Emergencia
    (field tipo)
    (field sector)
    (field campo)
)
(deftemplate SistemaExtincion
    (field tipo)
    (field status)
    (field UltimaRevision)
)
(defrule Emergencia-Fuego-ClaseB
    (Emergencia
        (tipo ClaseB))
    (SistemaExtincion
        (tipo DioxidoCarbono)
        (status operativo))
    =>
    (printout t "Usar extintor CO2" crlf)
)

(defrule Emergencia-Fuego
    (declare (salience 1000))
    ?Situacion <- (Emergencia
        (tipo ?Clase))
    =>
    (printout t "Peligro! Emergencia de tipo: " ?Clase crlf)
    (retract ?Situacion)
)