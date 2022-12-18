library(MASS)
Boston$chas = factor(Boston$chas) # chas 타입을 factor 로 변경(범주형 데이터로 간주)
Boston$rad = factor(Boston$rad)
summary(Boston)
Boston <- Bonston[,-15]
str(Boston)
my.control <- rpart.control(xval = 10 ,cp = 0, minsplit=nrow(Boston)*0.05)
fit.Boston = rpart(medv~., data = Boston, method ='anova', control= my.control)
printcp(fit.Boston)
cpnum = which.min(fit.Boston$cptable[,'xerror']) # xerror가 가장 낮은 행을 알려준다 
fit.prune.Boston <- prune(fit.Boston, cp = fit.Boston$cptable[cpnum],"CP")
fit.prune.Boston$variable.importance # 입력변수의 중요도 순서대로 나열 
rpart.plot(fit.prune.Boston)
