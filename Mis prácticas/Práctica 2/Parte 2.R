setwd("/mnt/A0DADA47DADA18FC/Fran/Universidad/3º/2 Cuatrimestre/IC/Mis prácticas/Práctica 2")

# -------------------------------------------------------------
# Abrir fichero de datos
# -------------------------------------------------------------
iris <- read.csv("./licenses.csv", sep = ' ', header = TRUE)
head(iris)
str(iris)

# -------------------------------------------------------------
# Explorar datos
# -------------------------------------------------------------
summary(iris)

library(ggplot2)
g <- ggplot(data = iris) +
  geom_point(aes(x = compatible_gnu, y = copyleft, color = class))
g
g <- ggplot(data = iris) +
  geom_point(aes(x = petal.length, y = petal.width, color = class)) +
  labs(x = "Petal Length", y = "Petal Width") +  
  scale_color_discrete(name ="Clase", labels=c("Iris Setosa", "Iris Versicolor", "Iris Virginica"))
g

# -------------------------------------------------------------
# Construir predictor
# -------------------------------------------------------------
library(caret)

# Crear conjunto de entrenamiento y validacion
train_index <- createDataPartition(iris$compatible_gnu, p = 0.7, list = FALSE, times = 1)
iris_train <- iris[ train_index, ]
iris_test  <- iris[-train_index, ]

# Crear clasificador
fit <- train(compatible_gnu ~ . , data = iris_train, method = "rpart")

# Estudiar clasificador
plot(fit)
plot(fit$finalModel)

library(partykit)
fit_party <- as.party(fit$finalModel)
plot(fit_party)

# Validar clasificador
predictions <- predict(fit, iris_test, type = "raw")
confusionMatrix(predictions, iris_test$class)

# Convertir en reglas
library(rattle)
asRules(fit$finalModel)

# Mas visualizaciones
fancyRpartPlot(fit$finalModel)

# -------------------------------------------------------------
# Crear 'tabla de compatibilidades'
# -------------------------------------------------------------

# Entrenamiento
set.seed(100)

left_table  <- iris_train[sample(nrow(iris_train), 50), ]
right_table <- iris_train[sample(nrow(iris_train), 50), ]
compatibility_table <- cbind(left_table, right_table)
colnames(compatibility_table) <- 
  c("sepal.length.1", "sepal.width.1", "petal.length.1", "petal.width.1", "class.1",
    "sepal.length.2", "sepal.width.2", "petal.length.2", "petal.width.2", "class.2")   
compatibility_table$compatible <- compatibility_table$class.1 == compatibility_table$class.2
compatibility_table$compatible <- factor(compatibility_table$compatible, labels = c("yes", "no"))
compatibility_table$class.1 <- NULL
compatibility_table$class.2 <- NULL

# Crear clasificador
fit_compatibility <- train(compatible ~ . , data = compatibility_table, method = "rpart")

# Visualizar
fancyRpartPlot(fit_compatibility$finalModel)

# Validar clasificador
set.seed(50)
left_table_test  <- iris_test[sample(nrow(iris_test), 50, replace = TRUE), ]
right_table_test <- iris_test[sample(nrow(iris_test), 50, replace = TRUE), ]
compatibility_table_test <- cbind(left_table_test, right_table_test)
colnames(compatibility_table_test) <- 
  c("sepal.length.1", "sepal.width.1", "petal.length.1", "petal.width.1", "class.1",
    "sepal.length.2", "sepal.width.2", "petal.length.2", "petal.width.2", "class.2")   
compatibility_table_test$compatible <- compatibility_table_test$class.1 == compatibility_table_test$class.2
compatibility_table_test$compatible <- factor(compatibility_table_test$compatible, labels = c("yes", "no"))
compatibility_table_test$class.1 <- NULL
compatibility_table_test$class.2 <- NULL

predictions_compatibility <- predict(fit_compatibility, compatibility_table_test, type = "raw")
confusionMatrix(predictions_compatibility, compatibility_table_test$compatible)

