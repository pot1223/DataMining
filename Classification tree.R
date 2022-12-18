install.packages("rpart") # rpart 패키지는 의사결정나무 분석 기능을 한다 
library(rpart)

Iris <- iris 

my.control <- rpart.control(xval=10, cp = 0, minsplit =5) # xval : 교차 타당성의 fold 개수,
# cp : 오분류율이 cp값 이상으로 향상되지 않으면 더 이상 분할하지 않는다,
# minsplit : 최소 분할 기준 관측치(Parent node total)

tree.model <- rpart(Species~., method ="class", control= my.control, data=Iris)
# method가 class면 분류나무, anova는 회귀나무, poisson은 포아송 회귀나무, exp는 생존나무다 

install.packages("rpart.plot") # 의사결정나무 그림을 그리기 위한 패키지 
library(rpart.plot)
rpart.plot(tree.model)

printcp(tree.model) # 최적의 complexity parameter(cp)를 지정한다 
# xerror가 증가하다가 줄어드는 순간의 CP를 최적의 cp로 지정한다 

pruned.model <- prune.rpart(tree.model, cp=0.02) # 가지치기 수행 
rpart.plot(pruned.model)


testdata <- data.frame(Petal.Width=c(0.2,2),
                       Petal.Length = c(1.4, 2.7),
                       Sepal.Width = c(3,4),
                       Sepal.Length = c(5,6)
)

predict(pruned.model, newdata = testdata, type ="class") # 데이터 분류
