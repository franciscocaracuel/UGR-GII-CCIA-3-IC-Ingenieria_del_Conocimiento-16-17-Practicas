;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Francisco Javier Caracuel Beltrán.
; Ingeniería del Conocimiento. GII.
; Curso 2016/2017.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Ejercicio de la familia.
; Se va a realizar el ejercicio sobre la familia de la serie "Modern Family"
; para que sea de fácil comprobación su funcionamiento.
; Junto a este fichero .clp, se encuentra una imagen "modern_family.jpg" donde
; aparece el árbol genealógico de esta familia.
; Para realizar este ejercicio no se tiene en cuenta la familia política (para
; tíos/tías, sobrinos/sobrinas, etc).

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Templates
;

; Se define un template para las personas
(deftemplate Person
    (field name)
    (field gender)
)

; Se define un template con la relacion de las personas_t
(deftemplate Relationship
    (field type)
    (field name1)
    (field name2)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Conocimiento
;

; Se añade el conocimiento de las personas.
(deffacts People
    (Person
        (name Dede)
        (gender F)
    )
    (Person
        (name Jay)
        (gender M)
    )
    (Person
        (name Gloria)
        (gender F)
    )
    (Person
        (name Manny)
        (gender M)
    )
    (Person
        (name Phil)
        (gender M)
    )
    (Person
        (name Claire)
        (gender F)
    )
    (Person
        (name Haley)
        (gender F)
    )
    (Person
        (name Alex)
        (gender F)
    )
    (Person
        (name Luke)
        (gender M)
    )
    (Person
        (name Mitchell)
        (gender M)
    )
    (Person
        (name Cam)
        (gender M)
    )
    (Person
        (name Lily)
        (gender F)
    )
)

; Se añade el conocimiento de las relaciones.
; Para las relaciones de descendencia en "name1" aparecerá el nombre del hijo/a
; y en "name2" aparecerá el nombre del padre/madre.
(deffacts Relationships
    (Relationship
        (type Married)
        (name1 Jay)
        (name2 Gloria)
    )
    (Relationship
        (type Offspring)
        (name1 Manny)
        (name2 Gloria)
    )
    (Relationship
        (type Divorced)
        (name1 Dede)
        (name2 Jay)
    )
    (Relationship
        (type Offspring)
        (name1 Claire)
        (name2 Dede)
    )
    (Relationship
        (type Offspring)
        (name1 Claire)
        (name2 Jay)
    )
    (Relationship
        (type Offspring)
        (name1 Mitchell)
        (name2 Dede)
    )
    (Relationship
        (type Offspring)
        (name1 Mitchell)
        (name2 Jay)
    )
    (Relationship
        (type Married)
        (name1 Phil)
        (name2 Claire)
    )
    (Relationship
        (type Offspring)
        (name1 Haley)
        (name2 Phil)
    )
    (Relationship
        (type Offspring)
        (name1 Haley)
        (name2 Claire)
    )
    (Relationship
        (type Offspring)
        (name1 Alex)
        (name2 Phil)
    )
    (Relationship
        (type Offspring)
        (name1 Alex)
        (name2 Claire)
    )
    (Relationship
        (type Offspring)
        (name1 Luke)
        (name2 Phil)
    )
    (Relationship
        (type Offspring)
        (name1 Luke)
        (name2 Claire)
    )
    (Relationship
        (type Married)
        (name1 Mitchell)
        (name2 Cam)
    )
    (Relationship
        (type Offspring)
        (name1 Lily)
        (name2 Mitchell)
    )
    (Relationship
        (type Offspring)
        (name1 Lily)
        (name2 Cam)
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reglas.
;

; Inicia la ejecución
(defrule Init
    (declare (salience -100))
    =>
    (assert (Continue))
)

; Pregunta si quiere que le pregunte
(defrule Continue
    (declare (salience -100))
    ?c <- (Continue)
    =>
    (printout t crlf)
    (printout t "Quieres que te pregunte? (S/N): ")
    (bind ?answer (read))
    (printout t crlf)
    (if (or (eq ?answer S) (eq ?answer s))
        then
        (assert (AskNames S))
        else
        (printout t "Gracias por haber utilizado el programa." crlf)
        (printout t crlf)
    )
    (retract ?c)
)

; Pide los nombres para buscar
(defrule AskNames
    (declare (salience 100))
    ?aN <- (AskNames S)
    =>
    (printout t crlf)
    (printout t "Introduce el primer nombre: ")
    (bind ?n1 (read) )
    (printout t "Introduce el segundo nombre: ")
    (bind ?n2 (read) )
    (printout t crlf)
    (assert (People ?n1 ?n2))
    (assert (Continue))
    (retract ?aN)
)

; Busca si están casados
(defrule Married
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    ; Se busca una relación de matrimonio. Puede ser en ambos sentidos.
    (or
        (Relationship
            (type Married)
            (name1 ?n1)
            (name2 ?n2)
        )
        (Relationship
            (type Married)
            (name1 ?n2)
            (name2 ?n1)
        )
        )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (printout t ?n1 " y " ?n2 " estan casados." crlf)
    (printout t crlf)
    (retract ?delete)
)

; Busca si están divorciados
(defrule Divorced
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    ; Se busca una relación en la que se hayan separado. Puede ser en ambos
    ; sentidos.
    (or
        (Relationship
            (type Divorced)
            (name1 ?n1)
            (name2 ?n2)
        )
        (Relationship
            (type Divorced)
            (name1 ?n2)
            (name2 ?n1)
        )
        )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (printout t ?n1 " y " ?n2 " estan separados." crlf)
    (printout t crlf)
    (retract ?delete)
)

; Busca los padres
(defrule Parents
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    ; Se busca una relación de descendientes, donde el primer nombre es el hijo
    ; o hija y el segundo es el padre o madre. Por esto, se intercambian las
    ; variables que han hecho match
    (Relationship
        (type Offspring)
        (name1 ?n2)
        (name2 ?n1)
    )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (if (eq ?g1 M)
        then
        (printout t ?n1 " es el padre de " ?n2 "." crlf)
        else
        (printout t ?n1 " es la madre de " ?n2 "." crlf)
    )
    (printout t crlf)
    (retract ?delete)
)

; Busca los hijos
(defrule Offspring
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    ; Se busca una relación de descendientes, donde el primer nombre es el hijo
    ; o hija y el segundo es el padre o madre
    (Relationship
        (type Offspring)
        (name1 ?n1)
        (name2 ?n2)
    )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (if (eq ?g1 M)
        then
        (printout t ?n1 " es el hijo de " ?n2 "." crlf)
        else
        (printout t ?n1 " es la hija de " ?n2 "." crlf)
    )
    (printout t crlf)
    (retract ?delete)
)

; Busca los hermanos
(defrule Siblings
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    (Person
        (name ?n3)
        (gender ?g3)
    )
    ; Se busca una relación de hermanos
    (and
        (Relationship
            (type Offspring)
            (name1 ?n1)
            (name2 ?n3)
        )
        (Relationship
            (type Offspring)
            (name1 ?n2)
            (name2 ?n3)
        )
    )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (if (eq ?g3 M)
        then
        (if (eq ?g1 M)
            then
            (printout t ?n1 " es el hermano de " ?n2 " porque su padre es " ?n3 "." crlf)
            else
            (printout t ?n1 " es la hermana de " ?n2 " porque su padre es " ?n3 "." crlf)
        )
        else
        (if (eq ?g1 M)
            then
            (printout t ?n1 " es el hermano de " ?n2 " porque su madre es " ?n3 "." crlf)
            else
            (printout t ?n1 " es la hermana de " ?n2 " porque su madre es " ?n3 "." crlf)
        )
    )
    (printout t crlf)
    (retract ?delete)
)

; Busca los abuelos
(defrule Grandparents
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    (Person
        (name ?n3)
        (gender ?g3)
    )
    ; Se busca una relación de abuelos
    ; El nombre1 es el padre del auxiliar (nombre3) y el auxiliar es el padre
    ; del nombre2
    (and
        (Relationship
            (type Offspring)
            (name1 ?n3)
            (name2 ?n1)
        )
        (Relationship
            (type Offspring)
            (name1 ?n2)
            (name2 ?n3)
        )
    )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (if (eq ?g3 M)
        then
        (if (eq ?g1 M)
            then
            (printout t ?n1 " es el abuelo de " ?n2 " porque " ?n3 " es el hijo de " ?n1 " y el padre de " ?n2 "." crlf)
            else
            (printout t ?n1 " es la abuela de " ?n2 " porque " ?n3 " es el hijo de " ?n1 " y el padre de " ?n2 "." crlf)
        )
        else
        (if (eq ?g1 M)
            then
            (printout t ?n1 " es el abuelo de " ?n2 " porque " ?n3 " es la hija de " ?n1 " y la madre de " ?n2 "." crlf)
            else
            (printout t ?n1 " es la abuela de " ?n2 " porque " ?n3 " es la hija de " ?n1 " y la madre de " ?n2 "." crlf)
        )
    )
    (printout t crlf)
    (retract ?delete)
)

; Busca los nietos
(defrule Grandchildren
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    (Person
        (name ?n3)
        (gender ?g3)
    )
    ; Se busca una relación de nietos.
    ; El padre del primer nombre debe ser el hijo del segundo.
    (and
        (Relationship
            (type Offspring)
            (name1 ?n1)
            (name2 ?n3)
        )
        (Relationship
            (type Offspring)
            (name1 ?n3)
            (name2 ?n2)
        )
    )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (if (eq ?g3 M)
        then
        (if (eq ?g1 M)
            then
            (printout t ?n1 " es el nieto de " ?n2 " porque " ?n3 " es el padre de " ?n1 " y el hijo de " ?n2 "." crlf)
            else
            (printout t ?n1 " es la nieta de " ?n2 " porque " ?n3 " es el padre de " ?n1 " y el hijo de " ?n2 "." crlf)
        )
        else
        (if (eq ?g1 M)
            then
            (printout t ?n1 " es el nieto de " ?n2 " porque " ?n3 " es la madre de " ?n1 " y la hija de " ?n2 "." crlf)
            else
            (printout t ?n1 " es la nieta de " ?n2 " porque " ?n3 " es la madre de " ?n1 " y la hija de " ?n2 "." crlf)
        )
    )
    (printout t crlf)
    (retract ?delete)
)

; Busca los primos
(defrule Cousins
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    (Person
        (name ?n5)
        (gender ?g5)
    )
    ; Se busca una relación de primos.
    ; Se tienen tres personas auxiliares: los padres de cada primo tienen que
    ; ser hermanos de una quinta persona.
    (and
        (Relationship
            (type Offspring)
            (name1 ?n1)
            (name2 ?n3)
        )
        (Relationship
            (type Offspring)
            (name1 ?n3)
            (name2 ?n5)
        )
        (Relationship
            (type Offspring)
            (name1 ?n4)
            (name2 ?n5)
        )
        (Relationship
            (type Offspring)
            (name1 ?n2)
            (name2 ?n4)
        )
    )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (if (eq ?g5 M)
        then
        (if (eq ?g1 M)
            then
            (printout t ?n1 " es el primo de " ?n2 " porque su abuelo es " ?n5 "." crlf)
            else
            (printout t ?n1 " es la prima de " ?n2 " porque su abuelo es " ?n5 "." crlf)
        )
        else
        (if (eq ?g1 M)
            then
            (printout t ?n1 " es el primo de " ?n2 " porque su abuela es " ?n5 "." crlf)
            else
            (printout t ?n1 " es la prima de " ?n2 " porque su abuela es " ?n5 "." crlf)
        )
    )
    (printout t crlf)
    (retract ?delete)
)

; Busca los tíos
(defrule AuntUncle
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    (Person
        (name ?n3)
        (gender ?g3)
    )
    ; Se busca una relación de tío/tía con sobrino/sobrina.
    ; Se tienen dos personas auxiliares. El padre/madre del tío/tía tiene que
    ; ser padre/madre del padre/madre del sobrino.
    (and
        (Relationship
            (type Offspring)
            (name1 ?n1)
            (name2 ?n4)
        )
        (Relationship
            (type Offspring)
            (name1 ?n3)
            (name2 ?n4)
        )
        (Relationship
            (type Offspring)
            (name1 ?n2)
            (name2 ?n3)
        )
    )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (if (eq ?g3 M)
        then
        (if (eq ?g1 M)
            then
            (printout t ?n1 " es el tio de " ?n2 " porque " ?n3 " es el hermano de " ?n1 " y el padre de " ?n2 "." crlf)
            else
            (printout t ?n1 " es la tia de " ?n2 " porque " ?n3 " es el hermano de " ?n1 " y el padre de " ?n2 "." crlf)
        )
        else
        (if (eq ?g1 M)
            then
            (printout t ?n1 " es el tio de " ?n2 " porque " ?n3 " es la hermana de " ?n1 " y la madre de " ?n2 "." crlf)
            else
            (printout t ?n1 " es la tia de " ?n2 " porque " ?n3 " es la hermana de " ?n1 " y la madre de " ?n2 "." crlf)
        )
    )
    (printout t crlf)
    (retract ?delete)
)

; Busca los sobrinos
(defrule NephewNiece
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    (Person
        (name ?n3)
        (gender ?g3)
    )
    ; Se busca una relación de sobrino/sobrina con tío/tia.
    ; Se tienen dos personas auxiliares. El padre/madre del nombre1 tiene que
    ; ser hermano del nombre2.
    (and
        (Relationship
            (type Offspring)
            (name1 ?n1)
            (name2 ?n3)
        )
        (Relationship
            (type Offspring)
            (name1 ?n3)
            (name2 ?n4)
        )
        (Relationship
            (type Offspring)
            (name1 ?n2)
            (name2 ?n4)
        )
    )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (if (eq ?g3 M)
        then
        (if (eq ?g1 M)
            then
            (printout t ?n1 " es el sobrino de " ?n2 " porque " ?n3 " es el padre de " ?n1 " y el hermano de " ?n2 "." crlf)
            else
            (printout t ?n1 " es la sobrina de " ?n2 " porque " ?n3 " es el padre de " ?n1 " y el hermano de " ?n2 "." crlf)
        )
        else
        (if (eq ?g1 M)
            then
            (printout t ?n1 " es el sobrino de " ?n2 " porque " ?n3 " es la madre de " ?n1 " y la hermana de " ?n2 "." crlf)
            else
            (printout t ?n1 " es la sobrina de " ?n2 " porque " ?n3 " es la madre de " ?n1 " y la hermana de " ?n2 "." crlf)
        )
    )
    (printout t crlf)
    (retract ?delete)
)

; Busca los cuñados
(defrule BrotherSisterInLaw
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    (Person
        (name ?n3)
        (gender ?g3)
    )
    ; Se busca una relación de cuñados.
    ; Nombre1 está casado/a con un auxiliar, que es hermano/a de nombre2.
    ; Pueden ser cuñados de dos maneras. Si pregunta como nombre1 el hermano o
    ; si se pregunta como nombre1 la pareja.
    ; Depende de como se haya añadido en la plantilla de las relaciones, puede
    ; haberse añadido el matrimonio en un orden que luego no coincida. Se añade
    ; la cláusula "or" para comprobar en ambas direcciones.
    (or
        (and
            (or
                (Relationship
                    (type Married)
                    (name1 ?n1)
                    (name2 ?n3)
                )
                (Relationship
                    (type Married)
                    (name1 ?n3)
                    (name2 ?n1)
                )
            )
            (Relationship
                (type Offspring)
                (name1 ?n3)
                (name2 ?n4)
            )
            (Relationship
                (type Offspring)
                (name1 ?n2)
                (name2 ?n4)
            )
        )
        (and
            (Relationship
                (type Offspring)
                (name1 ?n1)
                (name2 ?n4)
            )
            (Relationship
                (type Offspring)
                (name1 ?n3)
                (name2 ?n4)
            )
            (or
                (Relationship
                    (type Married)
                    (name1 ?n2)
                    (name2 ?n3)
                )
                (Relationship
                    (type Married)
                    (name1 ?n3)
                    (name2 ?n2)
                )
            )
        )
    )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (if (eq ?g1 M)
        then
        (printout t ?n1 " es el cuñado de " ?n2 " gracias a " ?n3 "." crlf)
        else
        (printout t ?n1 " es la cuñada de " ?n2 " gracias a " ?n3 "." crlf)
    )
    (printout t crlf)
    (retract ?delete)
)

; Busca los suegros
(defrule FatherMotherInLaw
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    (Person
        (name ?n3)
        (gender ?g3)
    )
    ; Se busca una relación de suegros. nombre1 es el suegro/a del nombre2.
    ; El hijo/a de nombre1 es la pareja de nombre2.
    ; La pareja de nombre1 es el padre/madre de nombre2.
    (or
        (and
            (Relationship
                (type Offspring)
                (name1 ?n3)
                (name2 ?n1)
            )
            (or
                (Relationship
                    (type Married)
                    (name1 ?n3)
                    (name2 ?n2)
                )
                (Relationship
                    (type Married)
                    (name1 ?n2)
                    (name2 ?n3)
                )
            )
        )
        (and
            (Relationship
                (type Offspring)
                (name1 ?n2)
                (name2 ?n3)
            )
            (or
                (Relationship
                    (type Married)
                    (name1 ?n3)
                    (name2 ?n1)
                )
                (Relationship
                    (type Married)
                    (name1 ?n1)
                    (name2 ?n3)
                )
            )
        )
    )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (if (eq ?g1 M)
        then
        (printout t ?n1 " es el suegro de " ?n2 " gracias a " ?n3 "." crlf)
        else
        (printout t ?n1 " es la suegra de " ?n2 " gracias a " ?n3 "." crlf)
    )
    (printout t crlf)
    (retract ?delete)
)

; Busca los yernos y nueras
(defrule SonDaughterInLaw
    (declare (salience 0))
    ?delete <- (People ?n1 ?n2)
    (Person
        (name ?n1)
        (gender ?g1)
    )
    (Person
        (name ?n2 & ~?n1)
        (gender ?g2)
    )
    (Person
        (name ?n3)
        (gender ?g3)
    )
    ; Se busca una relación de yernos o nueras.
    ; Es el opuesto a la regla de los suegros.
    (or
        (and
            (or
                (Relationship
                    (type Married)
                    (name1 ?n1)
                    (name2 ?n3)
                )
                (Relationship
                    (type Married)
                    (name1 ?n3)
                    (name2 ?n1)
                )
            )
            (Relationship
                (type Offspring)
                (name1 ?n3)
                (name2 ?n2)
            )
        )
        (and
            (Relationship
                (type Offspring)
                (name1 ?n1)
                (name2 ?n3)
            )
            (or
                (Relationship
                    (type Married)
                    (name1 ?n2)
                    (name2 ?n3)
                )
                (Relationship
                    (type Married)
                    (name1 ?n3)
                    (name2 ?n2)
                )
            )
        )
    )
    =>
    (printout t crlf)
    ; Para separar la respuesta por género, se comprueba si es hombre o mujer
    (if (eq ?g1 M)
        then
        (printout t ?n1 " es el yerno de " ?n2 " gracias a " ?n3 "." crlf)
        else
        (printout t ?n1 " es la nuera de " ?n2 " gracias a " ?n3 "." crlf)
    )
    (printout t crlf)
    (retract ?delete)
)

; Cuando no ha encontrado nada
(defrule Unknown
    (declare (salience -50))
    ?delete <- (People ?n1 ?n2)
    =>
    (printout t crlf)
    (printout t "No hemos encontrado ninguna relacion entre " ?n1 " y " ?n2 "." crlf)
    (printout t crlf)
    (retract ?delete)
)















;
