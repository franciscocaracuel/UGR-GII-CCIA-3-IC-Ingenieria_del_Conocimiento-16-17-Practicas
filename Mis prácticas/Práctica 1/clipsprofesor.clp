;;; Con templates

;; Poner tíos, abuelos, primos

(deftemplate Persona
  (field nombre)
  (field sexo)
  (multifield hijo-de)
)

(deftemplate RelacionFamiliar
    (field nombreRelacion)
    (field persona1)
    (field persona2)
)

(deffacts personas_t
   (Persona
      (nombre Homer)
      (sexo Hombre)
      (hijo-de Abe Mona)
   )
   (Persona
      (nombre Marge)
      (sexo Mujer)
      (hijo-de Clancy Jackie)
   )
   (Persona
      (nombre Bart)
      (sexo Hombre)
      (hijo-de Homer Marge)
   )
   (Persona
      (nombre Lisa)
      (sexo Mujer)
      (hijo-de Homer Marge)
   )
)

;;;; -------------------------

(defrule Iniciar
    (declare (salience 5))
    ;?i <- (iniciar)
    =>
    (printout t "Introduce nombre 1: ")
    (bind ?n1 (read) )
    (printout t "Introduce nombre 2: ")
    (bind ?n2 (read) )
    (assert (buscar_relaciones ?n1 ?n2))
    ;(retract ?i)
)
;; Se inicia con (assert(iniciar))

;; Reglas con templates
(defrule Hermano
	(buscar_relaciones ?nombre1 ?nombre2)
    (exists ; Para que solo se active una vez la regla
    	(Persona
    		(nombre ?nombre1)
    		(hijo-de $? ?progenitor1 $?)
    	)
    	(Persona
    		(nombre ?nombre2 & ~?nombre1)
    		(hijo-de $? ?progenitor1 $?)
    	)
    )
	=>
	(printout t ?nombre1 " es hermano de " ?nombre2 crlf)
)

(defrule Tio
    (buscar_relaciones ?nombre1 ?nombre2)
    ;; nombre1 y nombre2 son hijos de alguien nombre3
    (Persona
        (nombre ?nombre2)
        (hijo-de $? ?nombre3 $?)
    )
    ;; ese alguien es hermano de nombre1
    (Persona
        (nombre ?nombre3)
        (hijo-de $? ?padre1 $?)
    )
    (Persona
        (nombre ?nombre1 & ~?nombre3)
        (hijo-de $? ?padre1 $?)
    )
    ;; Si se quiere distinguir por sexo (aunque es mejor hacerlo con if):
    (Persona
        (nombre ?nombre3)
        (sexo Hombre)
    )
    =>
    (printout t ?nombre1 " es tio de " ?nombre2 crlf)
)

;;; Regla para lectura
(defrule ObtenerNombrePersonas
	=>
  	(printout t "Introduzca el nombre de la primera persona" crlf)
  	(bind ?persona1 (read))
	(printout t "Introduzca el nombre de la segunda persona" crlf)
	(bind ?persona2 (read))
	(assert (buscar_relaciones ?persona1 ?persona2))
)





;;; Reglas con lectura y asignacion de valores de busqueda
;; Reglas con templates
;(defrule Hermano
;	(buscar_relaciones ?hijo1 ?hijo2)
	;(hijo-de ?padre ?hijo1)
    ;(hijo-de ?padre ?hijo2)
    ;(test (neq ?hijo1 ?hijo2))
	;=>
	;(printout t ?hijo1 " es hermano de " ?hijo2 crlf)
;)

;;; Regla para lectura
(defrule ObtenerNombrePersonas
	=>
      	(printout t "Introduzca el nombre de la primera persona" crlf)
      	(bind ?persona1 (read))
	(printout t "Introduzca el nombre de la segunda persona" crlf)
	(bind ?persona2 (read))
	(assert (buscar_relaciones ?persona1 ?persona2))
)


;; Para hacerlo con "funciones"
(defrule Hermano
    (declare (salience 10))
    (Persona
        (nombre ?nombre1)
        (hijo-de $? ?padre1 $?)
    )
    (Persona
        (nombre ?nombre2 & ~?nombre1)
        (hijo-de $? ?padre1 $?)
    )
    =>
    (assert (
        RelacionFamiliar
            (nombreRelacion hermano)
            (persona1 ?nombre1)
            (persona2 ?nombre2)
        )
    )
)


(defrule Tio
    (declare (salience 10))
    (Persona
        (nombre ?nombre2)
        (hijo-de $? ?nombre3 $?)
    )
    (RelacionFamiliar
        (nombreRelacion hermano)
        (persona1 ?nombre3)
        (persona2 ?nombre1)
    )
    =>
    (assert (
        RelacionFamiliar
            (nombreRelacion tio)
            (persona1 ?nombre3)
            (persona2 ?nombre1)
        )
    )
)

(defrule ImprimirHermanos
    (buscar_relaciones ?a ?b)
    (hermano ?a ?b)
    =>
    (printout t ?a " es hermano de " ?b crlf)
)


(defrule ImprimirHermanos
    (buscar_relaciones ?a ?b)
    (tio ?a ?b)
    =>
    (printout t ?a " es tio de " ?b crlf)
)



;; FIN
