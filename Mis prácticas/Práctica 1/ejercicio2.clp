;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Francisco Javier Caracuel Beltrán.
; Ingeniería del Conocimiento. GII.
; Curso 2016/2017.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Ejercicio 2. Menú para elegir varias opciones.

; Es igual que el ejercicio 1, pero en este caso se guarda lo que se lee por
; teclado en un multifield. Ese multifield se recorrerá uno a uno y se procesará
; igual que se ha hecho en el ejercicio 1.
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
    ; Se espera a que el usuario teclee la opción y se guarda en "option".
    ; Se guarda en un multifield, separado cada valor por un espacio en blanco.
    ; Esto permite recorrer después el multifield cómodamente.
    (bind ?option (explode$ (readline)))
    (printout t "----------------------------" crlf crlf)
    ; Se elimina el hecho para no tener una lista de "showMenu" de todas las
    ; veces que haya aparecido el menú
    (retract ?idInit)
    ; Se recorre el multifield "option"
    (loop-for-count (?i 1 (length ?option)) do
        ; Se comprueban todos los valores al igual que se ha hecho en el
        ; ejercicios anterior
        (if (and (>= (nth$ ?i ?option) 1)(<= (nth$ ?i ?option) 4))
            then
                (printout t "La opcion " (nth$ ?i ?option) " es valida." crlf crlf)
                ; Como la opción es correcta, se guarda el hecho con la opción
                ;seleccionada
                (assert(Elegido (nth$ ?i ?option)))
            else
                (printout t (nth$ ?i ?option) " no es una opcion correcta." crlf)
                (printout t "Volvera a aparecer el menu." crlf crlf)
                ; Si la opción no ha sido correcta, se vuelve a añadir el hecho de
                ; mostrar el menú
                (assert(showMenu))
        )
    )
)
