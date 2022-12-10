install.packages("arules") # 거래 데이터를 희소 매트릭스 데이터 구조로 생성하기 위한 연관 규칙 패키지 
# 희소 매트릭스(sparse matrix) : 집합이 없는 칸에는 0을 저장한 행렬
library(arules)
groceries <- read.transactions("DATA/groceries.csv", sep =",") # read.transaction()함수를 통해 희소 매트릭스를 생성한다 
inspect(groceries[1:5]) # inspect()함수를 통해 거래를 확인 할 수 있다 
itemFrequency(groceries[,1:3]) # itemFrequenct()함수를 통해 support를 확인 할 수 있다 
itemFrequencyPlot(groceries, support = 0.1) # 최소 지지도 0.1 이상인 제품의 support plot를 나타낸다 
itemFrequencyPlot(groceries, topN = 20) # 상위 20개의 support plot을 나타낸다 
image(groceries[1:5]) # 매트릭스 묘사
image(sample(groceries,100)) # 무작위 샘플링한 거래에 대한 매트릭스 묘사

groceryrules <- apriori(groceries, parameter = list(support = 0.006, confidence = 0.25, minlen =2)) # 최소지지도, 최소 신뢰도, 최소 집합수를 선정 
summary(groceryrules)
inspect(sort(groceryrules, by ="confidence"))
berryrules <- subset(groceryrules, items %in% "berries") # 특정 item이 포함된 규칙을 검색
yogurtrules <- subset(groceryrules, items %in% c("berries", "yogurt"))
inspect(berryrules)
inspect(yogurtrules)

write(groceryrules, file = "groceryrules.csv", sep =",",quote =TRUE, row.names=FALSE) # 파일로 보내기 
groceryrules_df <- as(groceryrules, "data.frame") # 데이터 
