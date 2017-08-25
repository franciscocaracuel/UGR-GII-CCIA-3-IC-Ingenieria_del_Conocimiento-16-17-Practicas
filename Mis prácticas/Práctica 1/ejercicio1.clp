;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Francisco Javier Caracuel Beltrán.
; Ingeniería del Conocimiento. GII.
; Curso 2016/2017.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Ejercicio 1. Menú para elegir una opción.

; Si solo hubiese que ejecutar el menú la primera vez, se podría añadir el texto
; en "init", pero como si introduce una opción errónea, se debe volver a
; mostrar, se crea la regla "init".
; La regla "init" se ejecuta al inicio.
; Si cuando se muestra el menú, se selecciona una opción errónea, se hace un
; "assert" de "init", para que se vuelva a ejecutar.
; "init" añade el hecho "Menu1", que es el que muestra el menú.
(defrule init
    =>
    (assert (showMenu))
)

; La regla "Menu1" se ejecutará siempre que exista el hecho "showMenu".
(defrule Menu1
    ; Se guarda en "idInit" el id del hecho que ha saltado para quitarlo después
    ?idInit <- (showMenu)
    =>
    ; Se muestra el menú por pantalla
    (printout t crlf "----------------------------" crlf)
    (printout t "--- Menu del ejercicio 1 ---" crlf crlf )
    (printout t "Elige una opcion:" crlf crlf)
    (printout t "1. Seleccionar la opcion 1." crlf)
    (printout t "2. Seleccionar la opcion 2." crlf)
    (printout t "3. Seleccionar la opcion 3." crlf)
    (printout t "4. Seleccionar la opcion 4." crlf)
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
            (assert(OpcionElegida ?option))
        else
            (printout t "No has seleccionado una opcion correcta." crlf crlf)
            ; Si la opción no ha sido correcta, se vuelve a añadir el hecho de
            ; mostrar el menú
            (assert(showMenu))
    )
)
