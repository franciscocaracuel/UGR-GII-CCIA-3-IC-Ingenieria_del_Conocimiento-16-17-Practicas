;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Francisco Javier Caracuel Beltrán.
; Ingeniería del Conocimiento. GII.
; Curso 2016/2017.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Ejercicio 7. Leer datos de un fichero, procesarlos y guardarlo en otro
; fichero.

; Se utiliza el fichero .pdf subido a la web donde explica cómo leer datos de
; los archivos y cómo escribir en ellos.
; Se hacen las modificaciones en los nombres de los archivos que pide el
; ejercicio y se modifica la regla que escribe en el fichero, para que solo
; escriba si la etiqueta es "L" y para que borre todos los hechos que se han
; añadido al leer del fichero.
; Para reemplazar la palabra, se convierte a "multifield", se reemplaza y se
; vuelve a convertir a string.

; Regla inicial que sirve para pedir las dos palabras (la que tiene que cambiar
; y la que tiene que escribir)
(defrule init
    (declare (salience 50))
    =>
    (printout t crlf "Introduce la palabra que quieres buscar: ")
    (bind ?searchedWord (read))
    (printout t "Introduce la palabra con la que quieres reemplazar \"" ?searchedWord "\": ")
    (bind ?replacedWord (read))
    (printout t crlf)
    ; Se añaden dos hechos que indican las palabras
    (assert (searchedWord ?searchedWord))
    (assert (replacedWord ?replacedWord))
)

; Abre el fichero de lectura y lo guarda en mydata
(defrule openfile
    (declare (salience 30))
    =>
    (open "Mensajes.txt" mydata)
    (assert (SeguirLeyendo))
)

; Se lee línea a línea el fichero. Hasta que no llegue al final del fichero,
; seguirá añadiendo el hecho que lee la siguiente línea.
(defrule LeerValoresCierreFromFile
    (declare (salience 20))
    ?f <- (SeguirLeyendo)
    =>
    (bind ?Leido (read mydata))
    (retract ?f)
    (if (neq ?Leido EOF) then
        (assert (ValorCierre ?Leido (read mydata)))
        (assert (SeguirLeyendo))
    )
)

; Se cierra el fichero
(defrule closefile
    (declare (salience 10))
    =>
    (close mydata)
)

; Se abre el fichero en el que va a escribir el resultado
(defrule openfile2
    (declare (salience -20))
    =>
    (open "Mensaje_L.txt" mydata "w")
)

; Cada vez que encuentre el hecho "ValorCierre" ejecutará esta regla, que
; comprueba si la etiqueta es "L".
(defrule WriteData
    (declare (salience -30))
    ?f <- (ValorCierre ?valor ?x)
    ?s <- (searchedWord ?sW)
    ?r <- (replacedWord ?rW)
    =>
    ; Si la etiqueta es L, se escribe en el fichero la frase
    (if (eq ?valor L)
        then
        ; Comienza la transformación de la frase.
        ; Primero se convierte el string en un multifield.
        (bind ?sentence (explode$ ?x))
        ; Después se obtiene la posición donde está la palabra que se quiere
        ; cambiar
        (bind ?position (member$ ?sW ?sentence))
        ; Si la palabra que se quiere cambiar no existe, "member$" devuelve
        ; false.
        ; Si la palabra existe, se modifica. Si no existe se pone la frase
        ; original.
        (if (neq ?position FALSE)
            then
            ; Se transforma el multifield con la palabra nueva.
            (bind ?sentenceToSave (replace$ ?sentence ?position ?position ?rW))
            ; Se informa de que se va a cambiar.
            (printout t "Se ha escrito la nueva frase en el fichero." crlf crlf)
            ; Se escribe en el fichero cambiando el multifield en string.
            (printout mydata (implode$ ?sentenceToSave) crlf)
            else
            ; Si no existía la palabra, se avisa y se escribe la frase original.
            (printout t "La palabra \"" ?sW "\" no esta en la frase. Se escribe en el fichero sin modificar." crlf crlf)
            (printout mydata ?x crlf)
        )
        ; Se borran los hechos que guardaban las palabras pedidas.
        (retract ?s ?r)
    )
    ; Se borran todos los hechos leídos del fichero para hacer limpieza
    (retract ?f)
)

; Cierra el fichero de escritura
(defrule closefile2
    (declare (salience -40))
    =>
    (close mydata)
)

; Cuando se escribe en el fichero, pueden quedar hechos con las frases que se
; han leído que ya no sirven. Se borran para hacer limpieza.
(defrule Clean
    (declare (salience -30))
    ?f <- (ValorCierre ?valor ?x)
    =>
    (retract ?f)
)
