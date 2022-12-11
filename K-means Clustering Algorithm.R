# K-means Clustering 에서 군집중심개수를 결정하는 방법1 

install.packages("NbClust")
library(NbClust)
nc <- NbClust(training.data, min.nc =2, max.nc = 15, method = "kmeans") # K는 2부터 15까지 
# NbClust 패키지는 26개의 군집분석 알고리즘 중 최적 군집 개수를 알려준다 
par(mfrow = c(1,1))
barplot(table(nc$Best.n[1,]), xlab = "Number of Clusters", ylab = "Number of Criteria", main = "Number of Clusters Chosen") # 최적 군집 개수 판단 

# K-means Clustering 에서 군집중심개수를 결정하는 방법2

wssplot <- function(data, nc= 15, seed =1234) # nc로 최대 군집수, seed는 랜덤 난수 
  {
    wss <- (nrow(data)-1)*sum(apply(data,2,var)) # 열의 분산 합
    for(i in 2:nc)
      {
        set.seed(seed)
        wss[i] <- sum(kmeans(data, centers=i)$withinss)
      }
    plot(1:nc, wss, type='b',xlab = "Number of Clusters", ylab = "Within groups sum of squares")
  }

wssplot(training.data) # 거리 제곱합의 감소 폭이 둔화되는 수를 군집중심개수(K)로 정한다 

# k-means clustering Algorithm

install.packages("ggplot2")
library(ggplot2)
str(iris) # str는 structure의 약자로 str()은 데이터의 구조를 알려준다 
head(iris) # 처음 6개 데이터(행)를 나타내준다 
colSums(is.na(iris)) # colSums()는 열의 개수를 알려준다 

ggplot(data = iris, aes(x=Petal.Length, y= Petal.Width, color = Species)) +
  geom_point() + ggtitle("Petal.Length vs Petal.Width")

install.packages("caret")
library(caret) # caret 패캐지는 classifier, regression 모델을 간단하게 구축 및 검증 기능을 가진다
inTrain <- createDataPartition(y=iris$Species, p = 0.7, list =F)
# createDataPartition()함수는 훈련 및 테스트 데이터로 분할하는 함수로 Species 데이터 기준으로 70%를 가져간다 
training <- iris[inTrain,] # 훈련 데이터 
testing <- iris[inTrain,] # 평가 데이터 
training.data <- scale(training[-5]) # scale()을 사용하여 표준 정규화를 해서 단위의 영향을 없앤다
# training[-5]로 5번째 열인 Species 범주형 변수를 삭제해서 표준화가 가능하게 하였다 
View(training.data)
iris.kmeans <- kmeans(training.data[,-5], center = 3, iter.max = 10000) # center는 초기군집 수(K), iter.max는 반복횟수를 의미한다 
iris.kmeans$centers # 각 cluster의 중심값
training$cluster <- as.factor(iris.kmeans$cluster) # as.factor()를 통해 iris.kmeans의 cluster 속성을 training 의 속성에 붙인다 
qplot(Petal.Width, Petal.Length, color = cluster, data = training)
table(training$Species, training$cluster) 
