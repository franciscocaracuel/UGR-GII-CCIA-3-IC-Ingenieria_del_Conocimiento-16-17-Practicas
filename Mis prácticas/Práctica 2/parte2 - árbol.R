# Establecer el directorio de trabajo a la ruta donde este el 
# fichero .csv

licenses <- read.csv("./licenses.csv", sep = ' ', header = TRUE)

# -------------------------------------------------------------
# Crear 'tabla de compatibilidades'
# -------------------------------------------------------------

library(ggplot2)
library(caret)
library(rattle)
library(partykit)

# Entrenamiento
set.seed(1824)

rows = nrow(licenses)
cols = ncol(licenses)

compatibility_table = NULL

# Se crea una tabla con la combinación de todas las características
# con todas las licencias
for (i in c(1:rows)){
  
  for (j in c(1:rows)){
    
    compatibility_table = rbind(compatibility_table, 
                                cbind(licenses[i,], licenses[j,]))
    
  }
  
}

colnames(compatibility_table) <- 
  c("copyleft.1", "patentes.1", "ficheros_propietarios.1", "abierta.1",
    "propiedad_intelectual.1", "permisiva.1", "compatible_gnu.1", "compatible_osi.1",
    "copyleft.2", "patentes.2", "ficheros_propietarios.2", "abierta.2",
    "propiedad_intelectual.2", "permisiva.2", "compatible_gnu.2", "compatible_osi.2")   

compatibility_table$compatible <- compatibility_table$compatible_gnu.1 == compatibility_table$compatible_gnu.2
compatibility_table$compatible <- factor(compatibility_table$compatible, labels = c("no", "yes"))

compatibility_table$compatible_gnu.1 <- NULL
compatibility_table$compatible_gnu.2 <- NULL

# Crear clasificador
fit_compatibility <- train(compatible ~ . , data = compatibility_table, method = "rpart")

# Visualizar
fancyRpartPlot(fit_compatibility$finalModel)

