library(glmnet)

dados=read.csv("C:/Users/Gabriel/Documents/0-Estudos/Doutorado/Data Mining/Trabalho de curso/dados_cancer.csv")
#dados=read.csv2("dados_cancer.csv")


x = data.matrix(dados[,1:18])
y = dados[,19]

#cvfit=cv.glmnet(x, y, family="multinomial", type.multinomial = "ungrouped")
cvfit=cv.glmnet(x, y, family="multinomial", type.multinomial = "ungrouped", nfolds = 344)

# qual o numero de coeficientes não zero pra cada valor de lambda (acho que eh o numero medio por classe)
cvfit$nzero

# os erros pra cada lambda
cvfit$cvm

# achando o lambda do menor erro quadratico
which(cvfit$cvm==min(cvfit$cvm))
# na rodada aqui foi o indice 38

# comprovando que é o menor lambda
cvfit$lambda[which(cvfit$cvm==min(cvfit$cvm))]
cvfit$lambda.min

#quantos coeficientes médios não zero pra esse lambda
cvfit$nzero[which(cvfit$cvm==min(cvfit$cvm))]

# aqui você vê quais os coeficientes importantes pra cada classe
coef(cvfit, s = "lambda.min")

# pode fazer o mesmo pro lambda.1se, mas acho que nao precisa pq ja tem muito zero no mínimo

cvfit$lambda.1se
which(cvfit$lambda==cvfit$lambda.1se)
# aqui foi o 25

cvfit$lambda[which(cvfit$lambda==cvfit$lambda.1se)]
cvfit$lambda.1se

cvfit$nzero[which(cvfit$lambda==cvfit$lambda.1se)]
coef(cvfit, s = "lambda.1se")

# se voce quiser ver outro lambda

coef(cvfit, s = cvfit$lambda[27])
