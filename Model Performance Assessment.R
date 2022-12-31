# ROC curve (분류모형평가 : 반응변수가 범주형인 경우) 
install.packages("MASS")
library(MASS)
View(Pima.te) # Pima 인도 여성 당뇨병 데이터 로드 
install.packages("pROC") 
library(pROC)
data("Pima.te")
Diag_DF <- data.frame(Attribute = c(colnames(Pima.te)[1:7]), AUC = NA) 
for(i in 1:nrow(Diag_DF)){
  roc_result <- roc(Pima.te$type, Pima.te[,as.character(Diag_DF$Attribute[i])])
  Diag_DF[i,'AUC'] <- roc_result$auc
}
Diag_DF <- Diag_DF[order(-Diag_DF$AUC),]

glu_roc <- roc(Pima.te$type, Pima.te$glu)
plot.roc(glu_roc, 
         col="red",
         print.auc=TRUE,
         max.auc.polygon=TRUE, # auc의 최대 면적 출력 
         print.thres=TRUE, print.thres.pch=19,print.thres.col="red",
         auc.polygon = TRUE, auc.polygon.col = "#D1F2EB"
         )

ped_roc <- roc(Pima.te$type, Pima.te$ped)
plot.roc(glu_roc,
         col= "red",
         print.auc=TRUE, print.auc.adj=c(2.5,-8),
         max.auc.polygon=TRUE,
         print.thres=TRUE, print.thres.pch=19, print.thres.col = "red", print.thres.adj=c(0.3,-1.2),
         auc.polygon = TRUE, auc.polygon.col = "#D1F2EB"
         )
plot.roc(ped_roc,
         add=TRUE,
         col="blue",
         print.auc = TRUE, print.auc.adj=c(1.11,1.2),
         print.thres=TRUE, print.thres.pch = 19, print.thres.col = "blue", print.thres.adj=c(-0.085,1.1))
legend("bottomright",
       legend=c("glucose", "pedigree"),
       col = c("red","blue"), lwd=2)

# 예측모형 평가 : 반응변수가 수치형인 경우

model <- lm(dist~speed, data=cars)
pred <- predict(model)
install.packages("Metrics") # 평가 척도가 포함된 패키지 설치 
library(Metrics)
rmse(pred, cars$dist) # 동일한 측정단위를 적용하여 예측결과가 실제값보다 멀리 떨어질 수록 패널티를 부여한다 
mse(pred, cars$dist) #  예측결과가 실제값보다 멀리 떨어질 수록 패널티를 부여한다 
mae(pred, cars$dist) # 예측결과가 평균적으로 반응변수를 과대 예측하는지 또는 과소 예측하는지를 평가한다 
mape(pred, cars$dist) # 예측결과가 실제값 대비 몇 퍼센트 벗어나 있는지 확인한다 
