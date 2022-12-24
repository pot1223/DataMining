head(state.x77) # R에 내장되어 있는 데이터
states <- as.data.frame(state.x77[,c("Murder","Population","Illiteracy","Income","Frost")])
head(states)
model <- lm(Murder~., data = states)
plot(Murder~.,data=states)
par(mfrow = c(2,2))
plot(model)
summary(model)

# 다중공선성 제거

install.packages("car") # 다중공선성을 판단하기 위한 패키지 
car::vif(model)>10 # 분산팽창요인이 10보다 큰 변수를 삭제해서 다중공선성을 제거한다 


# 설명변수 제거 

model.con <- lm(Murder~1, data =states) # y=B0 인 회귀모형
model.forward <- step(model.con, scope = list(lower=model.con, upper=model), direction = "forward") #forward selection 방식
model.forward

model.backward <- step(model, scope= list(lower=model.con, upper=model),direction="backward") # backward elimination 방식 
model.backward

model.both <- step(model.con, scope=list(lower=model.con,upper=model),direction="both") # stepwise regression 방식 
model.both

# 예측 

pre_murder <- predict(model.both, newdata= states) # 점추정 
pre_murder <- as.data.frame(pre_murder)
pre_murder

pre_murder <- predict(model.both, newdata= states, interval = "confidence") # 95% 신뢰수준 구간추정  
pre_murder <- as.data.frame(pre_murder)
pre_murder

model2 <- cbind(pre_murder, states$Murder) # 예측한 살인률과 실제 살인률 비교 
model2

# 예측모형 성능평가(rmse, mse, mae, mape)

install.packages("Metrics")
library(Metrics)
rmse(states$Murder, pre_murder$fit)
mse(states$Murder, pre_murder$fit)
mae(states$Murder, pre_murder$fit)
mape(states$Murder, pre_murder$fit)
