driving_data <- data.frame(x1=c(4, 20, 3, 19, 17, 8, 19, 18), x2 =c(15,13,13,4,17,11,12,6))

View(driving_data)

dist <- dist(driving_data, method = "euclidean") # 행렬의 행들사이의 거리를 계산 

hc1 <- hclust(dist, method = "single") # single Linkage Method

hc2 <- hclust(dist, method = "complete") # complete Linkage Method

hc3 <- hclust(dist, method = "average") # average Linkage Method 

par(mfrow=c(1,3)) # R에서 출력되는 이미지 배열을 1X3으로 출력

plot(hc1);plot(hc2);plot(hc3) # Dendrogram
