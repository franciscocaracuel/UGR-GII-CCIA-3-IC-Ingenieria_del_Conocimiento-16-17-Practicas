;; Hechos

(deftemplate Persona
	(field nombre)
	(field sexo)
	(field madre)
	(field padre)
	(field hijo-de)
)

(deffacts personas
	(Persona
		(nombre Homer)
		(sexo Hombre))
	(Persona
		(nombre Bart)
		(sexo Hombre)
		(hijo-de Homer))
)

(deffacts relaciones_hijos
	(hijo-de Homer Bart))
(deffacts relaciones_casados
	(casado Homer Marge))


;; Reglas
(defrule imprimepadres
	(hijo-de ?padre ?hijo1)
	(nombre ?hijo1)
	=>
	(printout t ?hijo1 "es hijo de " ?padre crlf)
)

(defrule imprimehermanos
	(hijo-de ?padre ?hijo1)
	(hijo-de ?padre ?hijo2)
	=>
	(printout t ?hijo1 " es hermano de " ?hijo2 crlf)
)

(defrule Hermano
	(buscar_relaciones)
	(Persona
		(nombre ?nombre1)
		(hijo-de $? ?padre1 $?)
	)
	(Persona
		(nombre ?nombre2 & ~?nombre1)
		(hijo-de $? ?padre1 $?)
	)
	=>
	(printout t ?nombre1 " es hermano de " ?nombre crlf)
)


; Lectura
; página 30

(defrule ObtenerNombrePersonas
	=>
	(printout t "Introduzca el nombre de la primera persona: " crlf)
	(bind ?persona1 (read))
	(printout t "Introduzca el nombre de la segunda persona: " crlf)
	(bind ?persona2 (read))
	(assert (buscar_relaciones))
)














;;
