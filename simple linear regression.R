install.packages("MASS") # 여러가지 dataset을 포함하고 있는 패키지 
library(MASS)
data(cats) # MASS 패키지의 cats 데이터를 사용
model1 <- lm(cats$Hwt~cats$Bwt, data = cats) # lm(A~B) A:반응변수, B:회귀변수
summary(model1)
anova(model1) # ANOVA 검정으로 모델 유의성 검토  
plot(cats$Hwt~cats$Bwt , main ="cats plot")
abline(model1, col = "red") # 회귀직선 그리기 
par(mfrow = c(2,2))
plot(model1) #모형의 독립성, 정규성, 등분산성 검토 
