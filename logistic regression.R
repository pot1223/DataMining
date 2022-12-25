data <- read.csv("DATA/binary.csv")
data$rank <- as.factor(data$rank) # rank 변수는 범주형으로 바꾸어야 하므로 factor 처리한다 -> 더미변수가 생성된다 
train <- data[1:280,] # 7:3 
test <- data[281:400,]
model <- glm(admit ~., data = train, family = "binomial") # family = "binomial"을 통해 로지스틱 회귀모델을 생성한다 
summary(model)
anova(model, test="Chisq") # y변수가 범주형이므로 카이스퀘어 분석 수행, Resid.Dev(잔차)가 작아질수록 모델 성능이 좋다 

p <- predict(model, newdata = test, type = "response") # y가 이산형 변수이므로 response 추가 
table(round(p), test$admit ) # 실제값과 예측값 비교 
rmse(test$admit, round(p)) # Root - Mean Squared Error
