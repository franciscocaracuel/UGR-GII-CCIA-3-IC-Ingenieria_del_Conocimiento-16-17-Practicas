;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Francisco Javier Caracuel Beltrán.
;
; Ingeniería del Conocimiento. GII.
;
; Curso 2016/2017.
;
; Práctica 2 - Sistema Experto sobre cuestiones legales y software
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Si solo hubiese que ejecutar el menú la primera vez, se podría añadir el texto
; en "init", pero como si introduce una opción errónea, se debe volver a
; mostrar, se crea la regla "init".
; La regla "init" se ejecuta al inicio.
; Si cuando se muestra el menú, se selecciona una opción errónea, se hace un
; "assert" de "init", para que se vuelva a ejecutar.
; "init" añade el hecho "Menu", que es el que muestra el menú.
(defrule init
    =>
    ; En caso de que se quede bloqueado el fichero sin cerrar
    ;(close mydata)
    (assert (showMenu))
)

; La regla "Menu" se ejecutará siempre que exista el hecho "showMenu".
(defrule Menu
    (declare (salience -100))
    ; Se guarda en "idInit" el id del hecho que ha saltado para quitarlo después
    ?idInit <- (showMenu)
    =>
    ; Se muestra el menú por pantalla
    (printout t crlf "----------------------------" crlf)
    (printout t "--- Menu de la practica 2 - Sistema Experto ---" crlf crlf )
    (printout t "Elige una opcion:" crlf crlf)
    (printout t "1. Eleccion de licencia de software." crlf)
    (printout t "2. Compatibilidad de software a usar con la licencia de mi software." crlf)
    (printout t "3. Asesoramiento sobre ley de proteccion de datos." crlf)
    (printout t "4. Salir." crlf)
    (printout t "----------------------------" crlf)
    (printout t "Opcion elegida: ")
    ; Se espera a que el usuario teclee la opción y se guarda en "option"
    (bind ?option (read))
    (printout t "----------------------------" crlf crlf)
    ; Se elimina el hecho para no tener una lista de "showMenu" de todas las
    ; veces que haya aparecido el menú
    (retract ?idInit)
    ; Se comprueba si la opción se encuentra en el intervalo que se quiere
    (if (and (>= ?option 1)(<= ?option 4))
        then
            (printout t "La opcion " ?option " es valida." crlf crlf)
            ; Como la opción es correcta, se guarda el hecho con la opción
            ;seleccionada
            (assert(chosenOption ?option))
        else
            (printout t "No has seleccionado una opcion correcta." crlf crlf)
            ; Si la opción no ha sido correcta, se vuelve a añadir el hecho de
            ; mostrar el menú
            (assert(showMenu))
    )
)

; Opción "Salir"
(defrule option4
    (declare (salience -90))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 4)
    =>
    (printout t "Hasta luego!" crlf crlf)
    (retract ?idOption)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Primera parte de la práctica 2
;

; Primera pregunta que se hace tras seleccionar la opción 1 del menú.
; La numeración solo se utiliza para nombrar las reglas. Puede ser nombrada
; la 5 pregunta y ser la 2 en hacerse al usuario
(defrule option1-1
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 1)
    =>
    ; Pregunta
    (printout t "Quieres que la licencia sea compatible con GNU (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            ; Se guarda el motivo por el que se elige
            (assert (option1Reason "Es compatible con GNU"))
            ; Se inserta un hecho que es 1-1. El primer 1 por ser la parte 1
            ; de la práctica 2 y el siguiente 1 por haber respondido sí a la
            ; pregunta. En el "else" habrá un 0 por haber respondido no.
            ; A partir de ahora se concatena al final de los números la
            ; respuesta y así se puede seguir la dirección del árbol
            (assert (chosenOption 1-1))
        else
            (printout t "Has elegido: No." crlf crlf)
            ; Se guarda el motivo por el que se elige
            (assert (option1Reason "No es compatible con GNU"))
            (assert (chosenOption 1-0))
    )
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Segunda pregunta que se hace tras seleccionar la opción 1 del menú.
; La numeración solo se utiliza para nombrar las reglas. Puede ser nombrada
; la 5 pregunta y ser la 2 en hacerse al usuario
(defrule option1-2
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 1-1)
    =>
    ; Pregunta
    (printout t "Quieres que la licencia sea permisiva (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option1Reason "Es permisiva"))
            ; Cuando ya se sabe que es la última opción que se puede elegir
            ; para dar un motivo para elegir una licencia, se inserta la
            ; licencia que se va a proponer
            (assert (chosenLicense1 "OpenLDAP"))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option1Reason "No es permisiva"))
            (assert (chosenOption 1-10))
    )
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Tercera pregunta que se hace tras seleccionar la opción 1 del menú.
; La numeración solo se utiliza para nombrar las reglas. Puede ser nombrada
; la 5 pregunta y ser la 2 en hacerse al usuario
(defrule option1-3
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 1-10)
    =>
    ; Pregunta
    (printout t "Quieres que la licencia tenga Copyleft (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option1Reason "Tiene Copyleft"))
            ; Cuando ya se sabe que es la última opción que se puede elegir
            ; para dar un motivo para elegir una licencia, se inserta la
            ; licencia que se va a proponer
            (assert (chosenLicense1 "GPL"))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option1Reason "No tiene Copyleft"))
            (assert (chosenOption 1-100))
    )
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Cuarta pregunta que se hace tras seleccionar la opción 1 del menú.
; La numeración solo se utiliza para nombrar las reglas. Puede ser nombrada
; la 5 pregunta y ser la 2 en hacerse al usuario
(defrule option1-4
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 1-100)
    =>
    ; Pregunta
    (printout t "Quieres que la licencia sea abierta (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option1Reason "Es abierta"))
            ; Cuando ya se sabe que es la última opción que se puede elegir
            ; para dar un motivo para elegir una licencia, se inserta la
            ; licencia que se va a proponer
            (assert (chosenLicense1 "BSD"))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option1Reason "No es abierta"))
            (assert (chosenLicense1 "W3C"))
    )
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Quinta pregunta que se hace tras seleccionar la opción 1 del menú.
; La numeración solo se utiliza para nombrar las reglas. Puede ser nombrada
; la 5 pregunta y ser la 2 en hacerse al usuario
(defrule option1-5
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 1-0)
    =>
    ; Pregunta
    (printout t "Quieres que la licencia pueda contener ficheros propietarios (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option1Reason "Puede contener ficheros propietarios"))
            ; Cuando ya se sabe que es la última opción que se puede elegir
            ; para dar un motivo para elegir una licencia, se inserta la
            ; licencia que se va a proponer
            (assert (chosenLicense1 "APSL"))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option1Reason "No puede contener ficheros propietarios"))
            (assert (chosenOption 1-00))
    )
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Sexta pregunta que se hace tras seleccionar la opción 1 del menú.
; La numeración solo se utiliza para nombrar las reglas. Puede ser nombrada
; la 5 pregunta y ser la 2 en hacerse al usuario
(defrule option1-6
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 1-00)
    =>
    ; Pregunta
    (printout t "Quieres que la licencia tenga Copyleft (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option1Reason "Tiene Copyleft"))
            (assert (chosenOption 1-001))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option1Reason "No tiene Copyleft"))
            (assert (chosenOption 1-000))
    )
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Séptima pregunta que se hace tras seleccionar la opción 1 del menú.
; La numeración solo se utiliza para nombrar las reglas. Puede ser nombrada
; la 5 pregunta y ser la 2 en hacerse al usuario
(defrule option1-7
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 1-001)
    =>
    ; Pregunta
    (printout t "Quieres que la licencia sea abierta (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option1Reason "Es abierta"))
            (assert (chosenLicense1 "OSL"))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option1Reason "No es abierta"))
            (assert (chosenLicense1 "MPL"))
    )
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Octava pregunta que se hace tras seleccionar la opción 1 del menú.
; La numeración solo se utiliza para nombrar las reglas. Puede ser nombrada
; la 5 pregunta y ser la 2 en hacerse al usuario
(defrule option1-8
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 1-000)
    =>
    ; Pregunta
    (printout t "Quieres que la licencia contenga propiedad intelectual (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option1Reason "Contiene propiedad intelectual"))
            (assert (chosenLicense1 "CDDL"))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option1Reason "No contiene propiedad intelectual"))
            (assert (chosenOption 1-0000))
    )
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Novena pregunta que se hace tras seleccionar la opción 1 del menú.
; La numeración solo se utiliza para nombrar las reglas. Puede ser nombrada
; la 5 pregunta y ser la 2 en hacerse al usuario
(defrule option1-9
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 1-0000)
    =>
    ; Pregunta
    (printout t "Quieres que la licencia sea abierta (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option1Reason "Es abierta"))
            (assert (chosenLicense1 "Apache Software"))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option1Reason "No es abierta"))
            (assert (chosenOption 1-00000))
    )
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Décima pregunta que se hace tras seleccionar la opción 1 del menú.
; La numeración solo se utiliza para nombrar las reglas. Puede ser nombrada
; la 5 pregunta y ser la 2 en hacerse al usuario
(defrule option1-10
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 1-00000)
    =>
    ; Pregunta
    (printout t "Quieres que la licencia contenga patentes (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option1Reason "Contiene patentes"))
            (assert (chosenLicense1 "AFL"))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option1Reason "No contiene patentes"))
            (assert (chosenLicense1 "PHP"))
    )
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Define que regla es la que se ha indicado que se debe proponer
(defrule chosenLicense1
    (declare (salience -20))
    ; Se guarda el id para eliminarlo al final
    ?idLicense <- (chosenLicense1 ?license)
    =>
    (printout t "La licencia que proponemos es " ?license " porque:" crlf)
    (retract ?idLicense)
)

; Regla que mostrará por pantalla los motivos por los que se elige una licencia
(defrule reason1
    ; Debe tener mayor prioridad que el menú para que se adelante a él
    (declare (salience -50))
    ; Se guarda el id para eliminarlo al final
    ?idReason <- (option1Reason ?reason)
    =>
    (printout t "- " ?reason "." crlf)
    (retract ?idReason)
    (assert (showMenu))
)

;
; Fin de la primera parte de la práctica 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Segunda parte de la práctica 2
;

; Primera pregunta que se hace tras seleccionar la opción 2 del menú.
(defrule option2-1
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 2)
    =>
    ; Pregunta
    (printout t "Tu licencia contiene patentes (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option2Reason Own "Contiene patentes"))
            (assert (chosenOption 2-1))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option2Reason Own "No contiene patentes"))
            (assert (chosenOption 2-0))
    )
    (assert (showCompatible2 Own))
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Segunda pregunta que se hace tras seleccionar la opción 2 del menú.
(defrule option2-2
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 2-1)
    =>
    ; Pregunta
    (printout t "La libreria externa contiene patentes (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option2Reason Library "Contiene patentes"))
            ; Si es compatible
            (assert (compatible2 1))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option2Reason Library "No contiene patentes"))
            (assert (chosenOption 2-10))
    )
    (assert (showCompatible2 Library))
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Tercera pregunta que se hace tras seleccionar la opción 2 del menú.
(defrule option2-3
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 2-10)
    =>
    ; Pregunta
    (printout t "La libreria externa tiene copyleft (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option2Reason Library "Tiene Copyleft"))
            ; Si es compatible
            (assert (compatible2 1))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option2Reason Library "No tiene copyleft"))
            (assert (compatible2 0))
    )
    (assert (showCompatible2 Library))
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Cuarta pregunta que se hace tras seleccionar la opción 2 del menú.
(defrule option2-4
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 2-0)
    =>
    ; Pregunta
    (printout t "Tu programa tiene ficheros propietarios (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option2Reason Own "Tiene ficheros propietarios"))
            ; Si es compatible
            (assert (compatible2 1))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option2Reason Own "No tiene ficheros propietarios"))
            (assert (chosenOption 2-00))
    )
    (assert (showCompatible2 Own))
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Quinta pregunta que se hace tras seleccionar la opción 2 del menú.
(defrule option2-5
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 2-00)
    =>
    ; Pregunta
    (printout t "Tu programa tiene copyleft (S/N)?: ")
    ; Se guarda la respuesta en la variable "option"
    (bind ?option (read))
    ; Si se escribe S o s se entiende que sí, cualquier otro carácter se
    ; entiende como no
    (if (or (= (str-compare ?option "S") 0) (= (str-compare ?option "s") 0))
        then
            (printout t "Has elegido: Si." crlf crlf)
            (assert (option2Reason Own "Tiene copyleft"))
            ; Si es compatible
            (assert (compatible2 1))

        else
            (printout t "Has elegido: No." crlf crlf)
            (assert (option2Reason Own "No tiene copyleft"))
            (assert (compatible2 0))
    )
    (assert (showCompatible2 Own))
    ; Se elimina para seguir preguntando
    (retract ?idOption)
)

; Regla con la respuesta "sí son compatibles"/"no son compatibles"
(defrule compatible2
    (declare (salience -20))
    ; Se guarda el id para eliminarlo al final
    ?idCompatible <- (compatible2 ?compatible)
    =>
    ; Si es compatible
    (if (eq ?compatible 1)
        then
        (printout t "Las dos licencias son compatibles entre si porque:" crlf)
        else
        (printout t "Las dos licencias no son compatibles entre si porque:" crlf)
    )
    (retract ?idCompatible)
    (assert (showMenu))
)

; Regla con el motivo
(defrule compatible3
    (declare (salience -20))
    ; Se guarda el id para eliminarlo al final
    ?idCompatible <- (showCompatible2 Own)
    =>
    (printout t crlf "Tu licencia:" crlf)
    (retract ?idCompatible)
)

; Regla con el motivo
(defrule compatible4
    (declare (salience -40))
    ; Se guarda el id para eliminarlo al final
    ?idCompatible <- (showCompatible2 Library)
    =>
    (printout t  crlf "La libreria externa:" crlf)
    (retract ?idCompatible)
)

; Regla con el motivo
(defrule compatible5
    (declare (salience -30))
    ; Se guarda el id para eliminarlo al final
    ?idCompatible <- (option2Reason Own ?reason)
    =>
    (printout t "- " ?reason "." crlf)
    (retract ?idCompatible)
)

; Regla con el motivo
(defrule compatible6
    (declare (salience -50))
    ; Se guarda el id para eliminarlo al final
    ?idCompatible <- (option2Reason Library ?reason)
    =>
    (printout t "- " ?reason "." crlf)
    (retract ?idCompatible)
)

;
; Fin de la segunda parte de la práctica 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Tercera parte de la práctica 2
;

(deftemplate Law
    (field name)
    (field title)
    (field text)
)

(deffacts Laws
    (Law
        (name V_IX_1720_2007)
        (title "Titulo V y Titulo IX (capitulo V) del Real Decreto 1720\/2007, de 21 de diciembre")
        (text "Obligaciones previas al tratamiento de los datos. Procedimientos relacionados con las transferencias internacionales de datos")
    )
    (Law
        (name II_15_1999)
        (title "Titulo II de la Ley Organica 15\/1999 de Proteccion de Datos de Caracter Personal")
        (text "Principios de la proteccion de datos")
    )
    (Law
        (name 5_15_1999)
        (title "Articulo 5 de la Ley Organica 15\/1999 de Proteccion de Datos de Caracter Personal")
        (text "Derecho de informacion en la recogida de datos")
    )
    (Law
        (name 18_19_1720_2007)
        (title "Articulos 18 y 19 del Real Decreto 1720\/2007")
        (text "Acreditacion del cumplimiento del deber de informacion. Supuestos especiales.")
    )
    (Law
        (name 7_15_1999)
        (title "Articulo 7 de la Ley Organica 15\/1999 de Proteccion de Datos de Caracter Personal")
        (text "Datos especialmente protegidos.")
    )
)

(deffacts ARCO
    (ARCO 2 "Derecho de acceso.txt")
    (ARCO 3 "Derecho de rectificacion.txt")
    (ARCO 4 "Derecho de cancelacion.txt")
    (ARCO 5 "Derecho de oposicion.txt")
)

(deffacts OwnD
    (OwnData Name "Empresarios de España")
    (OwnData Address "Calle Agapito")
    (OwnData City Granada)
    (availableData 0)
)

(deffunction system-string (?arg)
   (bind ?arg (str-cat ?arg " > temp.txt"))
   (system ?arg)
   (open "temp.txt" temp "r")
   (bind ?rv (readline temp))
   (close temp)
   ?rv
)

; Pregunta los datos del cliente
(defrule GetData
    (declare (salience 100))
    ?d <- (getData)
    ?a <- (availableData 0)
    =>
    ; Se piden los datos
    (printout t "Nombre: ")
    (bind ?name (read))
    (printout t "Direccion: ")
    (bind ?address (read))
    (printout t "Ciudad: ")
    (bind ?city (read))
    (assert (Data Name ?name))
    (assert (Data Address ?address))
    (assert (Data City ?city))
    (retract ?d)
    (retract ?a)
    ; Se inserta este hecho para indicar que no se vuelvan a pedir los datos
    (assert (availableData 1))
)

; Primera pregunta que se hace tras seleccionar la opción 3 del menú.
(defrule option3-menu
    (declare (salience 0))
    ; Se guarda el id para eliminarlo al final
    ?idOption <- (chosenOption 3)
    =>
    (bind ?list(create$
    "Idelogia"
    "Afiliacion sindical"
    "Religion"
    "Vida sexual"
    "DNI"
    "Direccion"
    "Imagen"
    "Nombre y apellidos"
    "Firma"
    "Tarjeta sanitaria"
    "Estado civil"
    "Fecha de nacimiento"
    "Edad"
    "Sexo"
    "Nacionalidad"
    "Lengua materna"
    "Vivienda"
    "Propiedades"
    "Posesiones"
    "Aficiones"
    "Licencias"
    "Formacion"
    "Titulaciones"
    "Experiencia profesional"
    "Profesion"
    "Puestos de trabajo"
    "Negocios"
    "Licencias comerciales"
    "Subscripciones"
    "Ingresos"
    "Rentas"
    "Inversiones"
    "Bienes patrimoniales"
    "Prestamos"
    "Avales"
    "Datos bancarios"
    "Jubilacion"
    "Seguros"
    "Hipotecas"
    "Beneficios"
    "Transacciones financieras"
    ))
    ; Se muestra el menú por pantalla
    (printout t crlf "----------------------------" crlf)
    (printout t "--- Selecciona (separado por espacios) los datos que van a manejar el sistema ---" crlf crlf )
    (loop-for-count (?i 1 (length ?list)) do
        (printout t ?i". "(nth$ ?i ?list)"." crlf)
    )
    (printout t "----------------------------" crlf)
    (printout t "Opcion elegida: ")
    ; Se espera a que el usuario teclee la opción y se guarda en "option".
    ; Se guarda en un multifield, separado cada valor por un espacio en blanco.
    ; Esto permite recorrer después el multifield cómodamente.
    (bind ?option (explode$ (readline)))
    (printout t "----------------------------" crlf crlf)
    ; Se elimina el hecho para no tener una lista de "showMenu" de todas las
    ; veces que haya aparecido el menú
    (retract ?idOption)
    ; Se recorre el multifield "option"
    (loop-for-count (?i 1 (length ?option)) do
        ; Se comprueban todos los valores.
        ; Se puede hacer con switch o con if. If se hace muy tedioso con tanto
        ; if/else, pero switch necesita escribir todas u cada unas de las
        ; opciones. Aunque sea más largo, se utiliza switch/case
        ; chosen-31 indica que es la parte 3. 1 indica que es el subgrupo 1.
        (switch (nth$ ?i ?option)
            (case 1
                then
                    (assert(chosen-31 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-31))
            )
            (case 2
                then
                    (assert(chosen-31 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-31))
            )
            (case 3
                then
                    (assert(chosen-31 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-31))
            )
            (case 4
                then
                    (assert(chosen-31 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-31))
            )
            (case 5
                then
                    (assert(chosen-32 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-32))
            )
            (case 6
                then
                    (assert(chosen-32 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-32))
            )
            (case 7
                then
                    (assert(chosen-32 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-32))
            )
            (case 8
                then
                    (assert(chosen-32 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-32))
            )
            (case 9
                then
                    (assert(chosen-32 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-32))
            )
            (case 10
                then
                    (assert(chosen-32 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-32))
            )
            (case 11
                then
                    (assert(chosen-33 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-33))
            )
            (case 12
                then
                    (assert(chosen-33 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-33))
            )
            (case 13
                then
                    (assert(chosen-33 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-33))
            )
            (case 14
                then
                    (assert(chosen-33 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-33))
            )
            (case 15
                then
                    (assert(chosen-33 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-33))
            )
            (case 16
                then
                    (assert(chosen-33 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-33))
            )
            (case 17
                then
                    (assert(chosen-34 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-34))
            )
            (case 18
                then
                    (assert(chosen-34 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-34))
            )
            (case 19
                then
                    (assert(chosen-34 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-34))
            )
            (case 20
                then
                    (assert(chosen-34 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-34))
            )
            (case 21
                then
                    (assert(chosen-34 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-34))
            )
            (case 22
                then
                    (assert(chosen-35 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-35))
            )
            (case 23
                then
                    (assert(chosen-35 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-35))
            )
            (case 24
                then
                    (assert(chosen-35 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-35))
            )
            (case 25
                then
                    (assert(chosen-36 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-36))
            )
            (case 26
                then
                    (assert(chosen-36 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-36))
            )
            (case 27
                then
                    (assert(chosen-37 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-37))
            )
            (case 28
                then
                    (assert(chosen-37 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-37))
            )
            (case 29
                then
                    (assert(chosen-37 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-37))
            )
            (case 30
                then
                    (assert(chosen-38 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-38))
            )
            (case 31
                then
                    (assert(chosen-38 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-38))
            )
            (case 32
                then
                    (assert(chosen-38 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-38))
            )
            (case 33
                then
                    (assert(chosen-38 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-38))
            )
            (case 34
                then
                    (assert(chosen-38 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-38))
            )
            (case 35
                then
                    (assert(chosen-38 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-38))
            )
            (case 36
                then
                    (assert(chosen-38 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-38))
            )
            (case 37
                then
                    (assert(chosen-38 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-38))
            )
            (case 38
                then
                    (assert(chosen-38 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-38))
            )
            (case 39
                then
                    (assert(chosen-38 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-38))
            )
            (case 40
                then
                    (assert(chosen-38 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-38))
            )
            (case 41
                then
                    (assert(chosen-39 (nth$ (nth$ ?i ?option) ?list)))
                    (assert(available-39))
            )
        )
    )
)

; Punto 1 de la parte 3
; Regla para describir la cabecera de los datos del grupo 1
(defrule option3-1a
    (declare (salience 100))
    ; Se guarda el id para eliminarlo al final
    ?idAvailable <- (available-31)
    =>
    (printout t crlf "Datos especialmente protegidos:" crlf)
    (retract ?idAvailable)
    (assert (showMenu32a))
    (assert (identify 0))
)

; Regla para enumerar los datos del grupo 1
(defrule option3-1b
    (declare (salience 99))
    ; Se guarda el id para eliminarlo al final
    ?idChosen <- (chosen-31 ?data)
    =>
    (printout t "- " ?data "." crlf)
    (retract ?idChosen)
    (assert(chosen2-31 ?data))
)

; Regla para describir la cabecera de los datos del grupo 2
(defrule option3-2a
    (declare (salience 95))
    ; Se guarda el id para eliminarlo al final
    ?idAvailable <- (available-32)
    =>
    (printout t crlf "Datos de caracter identificativo:" crlf)
    (retract ?idAvailable)
    (assert (showMenu32a))
    (assert (identify 1))
)

; Regla para enumerar los datos del grupo 2
(defrule option3-2b
    (declare (salience 94))
    ; Se guarda el id para eliminarlo al final
    ?idChosen <- (chosen-32 ?data)
    =>
    (printout t "- " ?data "." crlf)
    (retract ?idChosen)
    (assert (identify2-yes ?data))
)

; Regla para describir la cabecera de los datos del grupo 3
(defrule option3-3a
    (declare (salience 90))
    ; Se guarda el id para eliminarlo al final
    ?idAvailable <- (available-33)
    =>
    (printout t crlf "Datos relativos a las caracteristicas personales:" crlf)
    (retract ?idAvailable)
    (assert (showMenu32a))
    (assert (identify 0))
)

; Regla para enumerar los datos del grupo 3
(defrule option3-3b
    (declare (salience 89))
    ; Se guarda el id para eliminarlo al final
    ?idChosen <- (chosen-33 ?data)
    =>
    (printout t "- " ?data "." crlf)
    (retract ?idChosen)
    (assert(chosen2-33 ?data))
)

; Regla para describir la cabecera de los datos del grupo 4
(defrule option3-4a
    (declare (salience 85))
    ; Se guarda el id para eliminarlo al final
    ?idAvailable <- (available-34)
    =>
    (printout t crlf "Datos relativos a las circunstancias sociales:" crlf)
    (retract ?idAvailable)
    (assert (showMenu32a))
    (assert (identify 0))
)

; Regla para enumerar los datos del grupo 4
(defrule option3-4b
    (declare (salience 84))
    ; Se guarda el id para eliminarlo al final
    ?idChosen <- (chosen-34 ?data)
    =>
    (printout t "- " ?data "." crlf)
    (retract ?idChosen)
    (assert(chosen2-34 ?data))
)

; Regla para describir la cabecera de los datos del grupo 5
(defrule option3-5a
    (declare (salience 80))
    ; Se guarda el id para eliminarlo al final
    ?idAvailable <- (available-35)
    =>
    (printout t crlf "Datos Academicos y profesionales:" crlf)
    (retract ?idAvailable)
    (assert (showMenu32a))
    (assert (identify 0))
)

; Regla para enumerar los datos del grupo 5
(defrule option3-5b
    (declare (salience 79))
    ; Se guarda el id para eliminarlo al final
    ?idChosen <- (chosen-35 ?data)
    =>
    (printout t "- " ?data "." crlf)
    (retract ?idChosen)
    (assert(chosen2-35 ?data))
)

; Regla para describir la cabecera de los datos del grupo 6
(defrule option3-6a
    (declare (salience 75))
    ; Se guarda el id para eliminarlo al final
    ?idAvailable <- (available-36)
    =>
    (printout t crlf "Detalles de empleo:" crlf)
    (retract ?idAvailable)
    (assert (showMenu32a))
    (assert (identify 0))
)

; Regla para enumerar los datos del grupo 6
(defrule option3-6ab
    (declare (salience 74))
    ; Se guarda el id para eliminarlo al final
    ?idChosen <- (chosen-36 ?data)
    =>
    (printout t "- " ?data "." crlf)
    (retract ?idChosen)
    (assert(chosen2-36 ?data))
)

; Regla para describir la cabecera de los datos del grupo 7
(defrule option3-7a
    (declare (salience 70))
    ; Se guarda el id para eliminarlo al final
    ?idAvailable <- (available-37)
    =>
    (printout t crlf "Datos que aportan Informacion comercial:" crlf)
    (retract ?idAvailable)
    (assert (showMenu32a))
    (assert (identify 0))
)

; Regla para enumerar los datos del grupo 7
(defrule option3-7b
    (declare (salience 69))
    ; Se guarda el id para eliminarlo al final
    ?idChosen <- (chosen-37 ?data)
    =>
    (printout t "- " ?data "." crlf)
    (retract ?idChosen)
    (assert(chosen2-37 ?data))
)

; Regla para describir la cabecera de los datos del grupo 8
(defrule option3-8a
    (declare (salience 65))
    ; Se guarda el id para eliminarlo al final
    ?idAvailable <- (available-38)
    =>
    (printout t crlf "Datos economicos, financieros y de seguros:" crlf)
    (retract ?idAvailable)
    (assert (showMenu32a))
    (assert (identify 0))
)

; Regla para enumerar los datos del grupo 8
(defrule option3-8b
    (declare (salience 64))
    ; Se guarda el id para eliminarlo al final
    ?idChosen <- (chosen-38 ?data)
    =>
    (printout t "- " ?data "." crlf)
    (retract ?idChosen)
    (assert(chosen2-38 ?data))
)

; Regla para describir la cabecera de los datos del grupo 9
(defrule option3-9a
    (declare (salience 60))
    ; Se guarda el id para eliminarlo al final
    ?idAvailable <- (available-39)
    =>
    (printout t crlf "Datos relativos a transacciones de bienes y servicios:" crlf)
    (retract ?idAvailable)
    (assert (showMenu32a))
    (assert (identify 0))
)

; Regla para enumerar los datos del grupo 9
(defrule option3-9b
    (declare (salience 59))
    ; Se guarda el id para eliminarlo al final
    ?idChosen <- (chosen-39 ?data)
    =>
    (printout t "- " ?data "." crlf)
    (retract ?idChosen)
    (assert(chosen2-39 ?data))
)

; Aparecerá el menú para seleccionar el tipo de organización que utilizará los
; datos
(defrule menu32a
    (declare (salience 50))
    ; Se guarda en "idInit" el id del hecho que ha saltado para quitarlo después
    ?idInit <- (showMenu32a)
    =>
    ; Se muestra el menú por pantalla
    (printout t crlf "----------------------------" crlf)
    (printout t "Elige el tipo de organizacion que utilizara los datos:" crlf crlf)
    (printout t "1. Usuarios domesticos." crlf)
    (printout t "2. Empresas privadas." crlf)
    (printout t "3. Organizaciones dependientes de las administraciones publicas." crlf)
    (printout t "----------------------------" crlf)
    (printout t "Opcion elegida: ")
    ; Se espera a que el usuario teclee la opción y se guarda en "option"
    (bind ?option (read))
    (printout t "----------------------------" crlf crlf)
    ; Se elimina el hecho para no tener una lista de "showMenu" de todas las
    ; veces que haya aparecido el menú
    (retract ?idInit)
    ; Se comprueba si la opción se encuentra en el intervalo que se quiere
    (if (and (>= ?option 1)(<= ?option 3))
        then
            (printout t "La opcion " ?option " es valida." crlf crlf)
            ; Como la opción es correcta, se guarda el hecho con la opción
            ;seleccionada
            (assert(chosenOption32a ?option))
            (assert (showMenu32b))
        else
            (printout t "No has seleccionado una opcion correcta." crlf crlf)
            ; Si la opción no ha sido correcta, se vuelve a añadir el hecho de
            ; mostrar el menú
            (assert (showMenu32a))
    )
)

; Aparecerá el menú para seleccionar el lugar geográfico donde se almacenarán
; los datos
(defrule menu32b
   (declare (salience 50))
   ; Se guarda en "idInit" el id del hecho que ha saltado para quitarlo después
   ?idInit <- (showMenu32b)
   =>
   ; Se muestra el menú por pantalla
   (printout t crlf "----------------------------" crlf)
   (printout t "Elige el lugar geografico donde se almacenaran los datos:" crlf crlf)
   (printout t "1. Espana." crlf)
   (printout t "2. Europa." crlf)
   (printout t "3. Fuera de Europa." crlf)
   (printout t "4. EEUU." crlf)
   (printout t "5. China." crlf)
   (printout t "----------------------------" crlf)
   (printout t "Opcion elegida: ")
   ; Se espera a que el usuario teclee la opción y se guarda en "option"
   (bind ?option (read))
   (printout t "----------------------------" crlf crlf)
   ; Se elimina el hecho para no tener una lista de "showMenu" de todas las
   ; veces que haya aparecido el menú
   (retract ?idInit)
   ; Se comprueba si la opción se encuentra en el intervalo que se quiere
   (if (and (>= ?option 1)(<= ?option 5))
       then
           (printout t "La opcion " ?option " es valida." crlf crlf)
           ; Como la opción es correcta, se guarda el hecho con la opción
           ;seleccionada
           (assert(chosenOption32b ?option))
           (assert (showMenu32c))
       else
           (printout t "No has seleccionado una opcion correcta." crlf crlf)
           ; Si la opción no ha sido correcta, se vuelve a añadir el hecho de
           ; mostrar el menú
           (assert (showMenu32b))
   )
)

; Aparecerá el menú para seleccionar el lugar geográfico donde se almacenarán
; los datos
(defrule menu32c
   (declare (salience 50))
   ; Se guarda en "idInit" el id del hecho que ha saltado para quitarlo después
   ?idInit <- (showMenu32c)
   =>
   ; Se muestra el menú por pantalla
   (printout t crlf "----------------------------" crlf)
   (printout t "Selecciona el uso que se le dara a los datos:" crlf crlf)
   (printout t "1. Uso personal." crlf)
   (printout t "2. Uso comercial." crlf)
   (printout t "3. Seguridad." crlf)
   (printout t "----------------------------" crlf)
   (printout t "Opcion elegida: ")
   ; Se espera a que el usuario teclee la opción y se guarda en "option"
   (bind ?option (read))
   (printout t "----------------------------" crlf crlf)
   ; Se elimina el hecho para no tener una lista de "showMenu" de todas las
   ; veces que haya aparecido el menú
   (retract ?idInit)
   ; Se comprueba si la opción se encuentra en el intervalo que se quiere
   (if (and (>= ?option 1)(<= ?option 3))
       then
           (printout t "La opcion " ?option " es valida." crlf crlf)
           ; Como la opción es correcta, se guarda el hecho con la opción
           ;seleccionada
           (assert(chosenOption32c ?option))
       else
           (printout t "No has seleccionado una opcion correcta." crlf crlf)
           ; Si la opción no ha sido correcta, se vuelve a añadir el hecho de
           ; mostrar el menú
           (assert (showMenu32c))
   )
   (assert (showLaw))
)

; Mostrar un mensaje que indica que los datos que se van a manejar identifican
; a una persona
(defrule identify-yes
   (declare (salience 40))
   ; Se guarda en "idInit" el id del hecho que ha saltado para quitarlo después
   ?idIdentify <- (identify 1)
   =>
   (printout t "Los datos que son suficientes para la identificacion de una persona son:" crlf)
   (retract ?idIdentify)
)

; Mostrar un mensaje que indica que los datos que se van a manejar identifican
; a una persona
(defrule identify2-yes
    (declare (salience 39))
    ; Se guarda en "idInit" el id del hecho que ha saltado para quitarlo después
    ?idIdentify <- (identify2-yes ?data)
    =>
    (printout t "- " ?data "." crlf)
    (retract ?idIdentify)
    (assert (identify2-yes-end))
)

(defrule identify2-yes-end
    (declare (salience 38))
    ; Se guarda en "idInit" el id del hecho que ha saltado para quitarlo después
    ?idIdentify <- (identify2-yes-end)
    =>
    (printout t crlf)
    (retract ?idIdentify)
)

; Muestra un conjunto de datos que pueden identificar a una persona
(defrule identify2-na1
    (declare (salience 35))
    ?idIdentify1 <- (chosen2-33 "Edad")
    ?idIdentify2 <- (chosen2-33 "Sexo")
    ?idIdentify3 <- (chosen2-34 "Vivienda")
    =>
    (printout t "El conjunto edad, sexo y vivienda puede identificar a una persona." crlf crlf)
    ;(retract ?idIdentify1)
    ;(retract ?idIdentify2)
    ;(retract ?idIdentify3)
)

; Muestra un conjunto de datos que pueden identificar a una persona
(defrule identify2-na2
    (declare (salience 35))
    ?idIdentify1 <- (chosen2-33 "Fecha de nacimiento")
    ?idIdentify2 <- (chosen2-34 "Vivienda")
    =>
    (printout t "El conjunto fecha de nacimiento y vivienda puede identificar a una persona." crlf crlf)
    ;(retract ?idIdentify1)
    ;(retract ?idIdentify2)
    ;(retract ?idIdentify3)
)

; Muestra un conjunto de datos que pueden identificar a una persona
(defrule identify2-na3
    (declare (salience 35))
    ?idIdentify1 <- (chosen2-33 "Fecha de nacimiento")
    ?idIdentify2 <- (chosen2-33 "Sexo")
    ?idIdentify3 <- (chosen2-35 "Formacion")
    =>
    (printout t "El conjunto fecha de nacimiento, sexo y formacion puede identificar a una persona." crlf crlf)
    ;(retract ?idIdentify1)
    ;(retract ?idIdentify2)
    ;(retract ?idIdentify3)
)

; Muestra un conjunto de datos que pueden identificar a una persona
(defrule identify2-na4
    (declare (salience 35))
    ?idIdentify1 <- (chosen2-33 "Fecha de nacimiento")
    ?idIdentify2 <- (chosen2-33 "Sexo")
    ?idIdentify3 <- (chosen2-36 "Profesion")
    =>
    (printout t "El conjunto fecha de nacimiento, sexo y profesion puede identificar a una persona." crlf crlf)
    ;(retract ?idIdentify1)
    ;(retract ?idIdentify2)
    ;(retract ?idIdentify3)
)

; Mostrar un mensaje que indica que los datos que se van a manejar no
; identifican a una persona
(defrule identify-no
   (declare (salience 30))
   ?idIdentify <- (identify 0)
   =>
   (printout t "Los datos que individualmente no son suficientes para la identificacion de una persona son:" crlf)
   (retract ?idIdentify)
)

; Mostrar un mensaje que indica que los datos que se van a manejar no
; identifican a una persona
(defrule identify2-no
    (declare (salience 29))
    (or (chosen2-31 ?data)
        (chosen2-33 ?data)
        (chosen2-34 ?data)
        (chosen2-35 ?data)
        (chosen2-36 ?data)
        (chosen2-37 ?data)
        (chosen2-38 ?data)
        (chosen2-39 ?data)
    )
    =>
    (printout t "- " ?data "." crlf)
    ;(retract ?idIdentify)
    (assert (identify2-no-end))
)

(defrule identify2-no-end
    (declare (salience 28))
    ?idIdentify <- (identify2-no-end)
    =>
    (printout t crlf)
    (retract ?idIdentify)
)

(defrule showLaw
    (declare (salience 10))
    ?idLaw <- (showLaw)
    =>
    (printout t "Las medidas que se deben implementar para cumplir la LOPD son:" crlf crlf)
    (retract ?idLaw)
    (assert (showLaw1))
)

(defrule showLaw1
    (declare (salience 50))
    ?idLaw <- (showLaw1)
    =>
    (printout t "- Inscripcion de ficheros:" crlf)
    (printout t "Todos y cada uno de los ficheros existentes en una empresa deben estar inscritos en el Registro General de Proteccion de
Datos para que sean publicos y esten accesibles para su consulta por cualquier interesado. Para ello, el empresario debe notificar la
existencia de los ficheros a la Agencia Espanola de Proteccion de datos utilizando del formulario de notificaciones telematicas a la AEPD" crlf)
    (printout t crlf "Ley: " crlf)
    (retract ?idLaw)
    (assert (showLaw V_IX_1720_2007))
    (assert (showLaw2))
)

(defrule showLaw2
    (declare (salience 50))
    ?idLaw <- (showLaw2)
    =>
    (printout t "- Calidad de los datos:" crlf)
    (printout t "Para cumplir con este principio, el empresario debe disenar un procedimiento de recogida, tratamiento y almacenamiento de
los datos que le permita dar cumplimiento a todas y cada una de las reglas que componen la calidad de los datos." crlf)
    (printout t crlf "Ley: " crlf)
    (retract ?idLaw)
    (assert (showLaw II_15_1999))
    (assert (showLaw3))
)

(defrule showLaw3
    (declare (salience 50))
    ?idLaw <- (showLaw3)
    =>
    (printout t "- Deber de informacion:" crlf)
    (printout t "Para cumplir con este principio, el empresario debe elaborar las clausulas informativas y disenar los procedimientos que
sean necesarios para informar debidamente al ciudadano y demostrar posteriormente que ha cumplido con su obligacion." crlf)
    (printout t crlf "Ley: " crlf)
    (retract ?idLaw)
    (assert (showLaw 5_15_1999))
    (assert (showLaw 18_19_1720_2007))
    (assert (showLaw4))
)

(defrule showLaw4
    (declare (salience 50))
    ?idLaw <- (showLaw4)
    =>
    (printout t "- Consentimiento del afectado:" crlf)
    (printout t "En los casos en los que sea necesario el consentimiento del afectado, el empresario debediseñar las cláusulas y los
procedimientos que sean necesarios para obtener el consentimiento válido del titular de los datos y demostrar posteriormente que ha
cumplido con dicha obligación." crlf)
    (printout t crlf "Ley: " crlf)
    (retract ?idLaw)
    (assert (showLaw II_15_1999))
    (assert (showLaw5))
)

(defrule showLaw5
    (declare (salience 50))
    ?idLaw <- (showLaw5)
    =>
    (printout t "- Datos especialmente protegidos:" crlf)
    (printout t "Para tratar correctamente los datos especialmente protegidos, además de adoptar las medidas de seguridad de nivel
alto, el empresario debe diseñar las cláusulas y los procedimientos que sean necesarios para obtener el consentimiento válido del
titular de los datos y demostrar posteriormente que ha cumplido con dicha obligación." crlf)
    (printout t crlf "Ley: " crlf)
    (retract ?idLaw)
    (assert (showLaw 7_15_1999))
    (assert (showMenu35))
)

(defrule showLawText
    (declare (salience 60))
    (Law (name ?n1) (title ?n2) (text ?n3))
    ?idLaw <- (showLaw ?n1)
    =>
    (printout t ?n2 ". " crlf ?n3 "." crlf crlf)
    (retract ?idLaw)
)

(defrule showLaw-end
    (declare (salience -80))
    ?idShow <- (showLaw)
    =>
    (retract ?idShow)
)

; Aparecerá el menú para ejercer los derechos ARCO
(defrule menu35
   (declare (salience 50))
   ?idInit <- (showMenu35)
   =>
   ; Se muestra el menú por pantalla
   (printout t crlf "----------------------------" crlf)
   (printout t "Selecciona el tipo de documento ARCO que quieres generar:" crlf crlf)
   (printout t "1. Derecho de informacion." crlf)
   (printout t "2. Derecho de acceso." crlf)
   (printout t "3. Derecho de rectificacion." crlf)
   (printout t "4. Derecho de cancelacion." crlf)
   (printout t "5. Derecho de oposicion." crlf)
   (printout t "6. Salir." crlf)
   (printout t "----------------------------" crlf)
   (printout t "Opcion elegida: ")
   ; Se espera a que el usuario teclee la opción y se guarda en "option"
   (bind ?option (read))
   (printout t "----------------------------" crlf crlf)
   (retract ?idInit)
   ; Se comprueba si la opción se encuentra en el intervalo que se quiere
   (if (and (>= ?option 1)(<= ?option 6))
       then
       (printout t "La opcion " ?option " es valida." crlf crlf)
       (if (and (>= ?option 1)(<= ?option 5))
           then
               ; Como la opción es correcta, se guarda el hecho con la opción
               ;seleccionada
               (assert (chosenOption35 ?option))
               ; Se piden los datos en el caso de que no se hayan pedido
               (assert (getData))
           else
               ; Si la opción es salir, se vuelve a añadir el hecho de
               ; mostrar el menú
               (assert (showMenu))
       )
       else
           (printout t "No has seleccionado una opcion correcta." crlf crlf)
           ; Si la opción no ha sido correcta, se vuelve a añadir el hecho de
           ; mostrar el menú
           (assert (showMenu35))
   )
)

(defrule option35-1
    (declare (salience 0))
    ?idOption <- (chosenOption35 1)
    =>
    (printout t "Derechos de informacion:" crlf crlf)
    (printout t "Si se van a registrar y tratar datos de carácter personal, sera necesario informar previamente a los
interesados, a traves del medio que se utilice para la recogida, de modo expreso, preciso e inequivoco:" crlf)
    (printout t "- De la existencia de un fichero o tratamiento de datos de caracter personal, de la finalidad de la recogida
de estos y de los destinatarios de la informacion.
- Del caracter obligatorio o facultativo de su respuesta a las preguntas que les sean planteadas.
- De las consecuencias de la obtención de los datos o de la negativa a suministrarlos.
- De la posibilidad de ejercitar los derechos de acceso, rectificacion, cancelacion y oposicion.
- De la identidad y direccion del responsable del tratamiento o, en su caso, de su representante." crlf crlf)
    (printout t "Cuando se utilicen cuestionarios u otros impresos para la recogida, figuraran en los mismos, en forma
claramente legible, las referidas advertencias." crlf)
    (retract ?idOption)
    (assert (showMenu35))
)

; Abre el fichero donde se guardará el contenido
(defrule openFile
    (declare (salience 0))
    ?idOption <- (chosenOption35 ?option)
    (ARCO ?option ?file)
    =>
    (open ?file mydata "w")
    (retract ?idOption)

    (assert (write35 ?option))
)

; Escribe en el fichero los datos con la plantilla
(defrule WriteData2
    (declare (salience 100))
    ?w <- (write35 2)
    (OwnData Name ?ownName)
    (OwnData Address ?ownAddress)
    (OwnData City ?ownCity)
    (Data Name ?name)
    (Data Address ?address)
    (Data City ?city)
    =>
    (printout mydata "A. DERECHO DE ACCESO." crlf)
    (printout mydata "A.1. EJERCICIO DEL DERECHO DE ACCESO." crlf)
    (printout mydata "DATOS DEL RESPONSABLE DEL FICHERO." crlf)
    (printout mydata "Nombre / razón social: " ?ownName crlf)
    (printout mydata "Dirección: " ?ownAddress crlf)
    (printout mydata "Ciudad: " ?ownCity crlf crlf)

    (printout mydata "DATOS DEL INTERESADO." crlf)
    (printout mydata "Nombre / razón social: " ?name crlf)
    (printout mydata "Dirección: " ?address crlf)
    (printout mydata "Ciudad: " ?city)
    (printout mydata ",
por medio del presente escrito ejerce el derecho de acceso, de conformidad con lo previsto en el
artículo 15 de la Ley Orgánica 15/1999, de 13 de diciembre, de Protección de Datos de Carácter Personal y en los
artículos 27 y 28 del Real Decreto 1720/2007, de 21 de diciembre, por el que se desarrolla la misma, y en consecuencia,

SOLICITA,

Que se le facilite gratuitamente el derecho de acceso a sus ficheros en el plazo máximo de un mes a contar desde la
recepción de esta solicitud, y que se remita por correo la información a la dirección arriba indicada en el plazo
de diez días a contar desde la resolución estimatoria de la solicitud de acceso.
Asimismo, se solicita que dicha información comprenda, de modo legible e inteligible, los datos de base que sobre mi
persona están incluidos en sus ficheros, los resultantes de cualquier elaboración, proceso o tratamiento, así como el
origen de los mismos, los cesionarios y la especificación de los concretos usos y finalidades para los que se almacenaron.

En Granada, a " (sub-string 1 2 (system-string "date /t")) " de " (sub-string 4 5 (system-string "date /t")) " de " (sub-string 7 10 (system-string "date /t")) "." crlf)

    (assert (closeFile))
    (retract ?w)
)

; Escribe en el fichero los datos con la plantilla
(defrule WriteData3
    (declare (salience 100))
    ?w <- (write35 3)
    (OwnData Name ?ownName)
    (OwnData Address ?ownAddress)
    (OwnData City ?ownCity)
    (Data Name ?name)
    (Data Address ?address)
    (Data City ?city)
    =>
    (printout mydata "A. DERECHO DE RECTIFICACION." crlf)
    (printout mydata "A.1. EJERCICIO DEL DERECHO DE RECTIFICACION." crlf)
    (printout mydata "DATOS DEL RESPONSABLE DEL FICHERO." crlf)
    (printout mydata "Nombre / razón social: " ?ownName crlf)
    (printout mydata "Dirección: " ?ownAddress crlf)
    (printout mydata "Ciudad: " ?ownCity crlf crlf)

    (printout mydata "DATOS DEL INTERESADO." crlf)
    (printout mydata "Nombre / razón social: " ?name crlf)
    (printout mydata "Dirección: " ?address crlf)
    (printout mydata "Ciudad: " ?city)
    (printout mydata ",
por medio del presente escrito ejerce el derecho de rectificación sobre los datos anexos, aportando los correspondientes
justificantes, de conformidad con lo previsto en el artículo 16 de la Ley Orgánica 15/1999, de 13 de diciembre, de
Protección de Datos de Carácter Personal y en los artículos 31 y 32 del Real Decreto 1720/2007, de 21 de diciembre,
por el que se desarrolla la misma y en consecuencia,

SOLICITA,

Que se proceda a acordar la rectificación de los datos personales sobre los cuales se ejercita el derecho, que se realice
en el plazo de diez días a contar desde la recogida de esta solicitud, y que se me notifique de forma escrita el resultado
de la rectificación practicada.
Que en caso de que se acuerde, dentro del plazo de diez días hábiles, que no procede acceder a practicar total o parcialmente
las rectificaciones propuestas, se me comunique motivadamente a fin de, en su caso, solicitar la tutela de la Agencia
Española de Protección de Datos, al amparo del artículo 18 de la citada Ley Orgánica 15/1999.
Que si los datos rectificados hubieran sido comunicados previamente se notifique al responsable del fichero la rectificación
practicada, con el fin de que también éste proceda a hacer las correcciones oportunas para que se respete el deber de calidad
de los datos a que se refiere el artículo 4 de la mencionada Ley Orgánica 15/1999.

En Granada, a " (sub-string 1 2 (system-string "date /t")) " de " (sub-string 4 5 (system-string "date /t")) " de " (sub-string 7 10 (system-string "date /t")) "." crlf)

    (assert (closeFile))
    (retract ?w)
)

; Escribe en el fichero los datos con la plantilla
(defrule WriteData4
    (declare (salience 100))
    ?w <- (write35 4)
    (OwnData Name ?ownName)
    (OwnData Address ?ownAddress)
    (OwnData City ?ownCity)
    (Data Name ?name)
    (Data Address ?address)
    (Data City ?city)
    =>
    (printout mydata "A. DERECHO DE CANCELACION." crlf)
    (printout mydata "A.1. EJERCICIO DEL DERECHO DE CANCELACION." crlf)
    (printout mydata "DATOS DEL RESPONSABLE DEL FICHERO." crlf)
    (printout mydata "Nombre / razón social: " ?ownName crlf)
    (printout mydata "Dirección: " ?ownAddress crlf)
    (printout mydata "Ciudad: " ?ownCity crlf crlf)

    (printout mydata "DATOS DEL INTERESADO." crlf)
    (printout mydata "Nombre / razón social: " ?name crlf)
    (printout mydata "Dirección: " ?address crlf)
    (printout mydata "Ciudad: " ?city)
    (printout mydata ",
por medio del presente escrito ejerce el derecho de cancelación, de conformidad con lo previsto en el artículo 16
de la Ley Orgánica 15/1999, de 13 de diciembre, de Protección de Datos de Carácter Personal y en los artículos 31
y 32 del Real Decreto 1720/2007, de 21 de diciembre, por el que se desarrolla la misma y en consecuencia,

SOLICITA,

Que se proceda a acordar la cancelación de los datos personales sobre los cuales se ejercita el derecho, que se
realice en el plazo de diez días a contar desde la recogida de esta solicitud, y que se me notifique de forma escrita
el resultado de la cancelación practicada.
Que en caso de que se acuerde dentro del plazo de diez días hábiles que no procede acceder a practicar total o
parcialmente las cancelaciones propuestas, se me comunique motivadamente a fin de, en su caso, solicitar la tutela
de la Agencia Española de Protección de Datos, al amparo del artículo 18 de la citada Ley Orgánica 15/1999.
Que si los datos cancelados hubieran sido comunicados previamente se notifique al responsable del fichero la cancelación
practicada con el fin de que también éste proceda a hacer las correcciones oportunas para que se respete el deber de
calidad de los datos a que se refiere el artículo 4 de la mencionada Ley Orgánica 15/1999.

En Granada, a " (sub-string 1 2 (system-string "date /t")) " de " (sub-string 4 5 (system-string "date /t")) " de " (sub-string 7 10 (system-string "date /t")) "." crlf)

    (assert (closeFile))
    (retract ?w)
)

; Escribe en el fichero los datos con la plantilla
(defrule WriteData5
    (declare (salience 100))
    ?w <- (write35 5)
    (OwnData Name ?ownName)
    (OwnData Address ?ownAddress)
    (OwnData City ?ownCity)
    (Data Name ?name)
    (Data Address ?address)
    (Data City ?city)
    =>
    (printout mydata "A. DERECHO DE OPOSICION." crlf)
    (printout mydata "A.1. EJERCICIO DEL DERECHO DE OPOSICION." crlf)
    (printout mydata "DATOS DEL RESPONSABLE DEL FICHERO." crlf)
    (printout mydata "Nombre / razón social: " ?ownName crlf)
    (printout mydata "Dirección: " ?ownAddress crlf)
    (printout mydata "Ciudad: " ?ownCity crlf crlf)

    (printout mydata "DATOS DEL INTERESADO." crlf)
    (printout mydata "Nombre / razón social: " ?name crlf)
    (printout mydata "Dirección: " ?address crlf)
    (printout mydata "Ciudad: " ?city)
    (printout mydata ",
por medio del presente escrito ejerzo el derecho de oposición, de conformidad con lo previsto en los artículos 6.4, 17
y 30.4 de la Ley Orgánica 15/1999, de 13 de diciembre, de Protección de Datos de carácter personal y en los artículos
34 y 35 del Real Decreto 1720/2007, de 21 de diciembre , que la desarrolla y en consecuencia,

EXPONGO,

(describir la situación en la que se produce el tratamiento de sus datos personales y enumerar los motivos por
los que se opone al mismo)

Para acreditar la situación descrita, acompaño una copia de los siguientes documentos:

(enumerar los documentos que adjunta con esta solicitud para acreditar la situación que ha descrito)

SOLICITO, Que sea atendido mi ejercicio del derecho de oposición en los términos anteriormente expuestos.

En Granada, a " (sub-string 1 2 (system-string "date /t")) " de " (sub-string 4 5 (system-string "date /t")) " de " (sub-string 7 10 (system-string "date /t")) "." crlf)

    (assert (closeFile))
    (retract ?w)
)

; Se cierra el fichero
(defrule closefile
    (declare (salience 0))
    ?f <- (closeFile)
    =>
    (close mydata)
    (retract ?f)
    (assert (showMenu35))
    (printout t crlf "Se ha generado el fichero" crlf)
)

;
; Fin de la tercera parte de la práctica 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
