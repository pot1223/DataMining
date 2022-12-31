install.packages("tm") # 텍스트 마이닝 패키지
install.packages("SnowballC") # 어근 추출을 위한 패키지(형태소 분석)
install.packages("wordcloud") 

library(tm)
library(SnowballC)
library(wordcloud)

filePath <- "http://datascienceplus.com/wp-content/uploads/2015/08/JEOPARDY_CSV.csv"
text <- readLines(filePath)
jeopardy <- read.csv(filePath, stringsAsFactors = FALSE, nrows = 1000) #stringsAsFactors : 문자열을 팩터(범주형)로 저장하는지에 대한 여부 

data_corpus <- Corpus(VectorSource(jeopardy$Question)) # Bag of words
data_corpus <- tm_map(data_corpus, content_transformer(tolower)) # 소문자 이외 제거(고유명사 제외)
data_corpus <- tm_map(data_corpus, removePunctuation) # 구두점 제거
data_corpus <- tm_map(data_corpus, removeNumbers) # 숫자 제거
data_corpus <- tm_map(data_corpus, removeWords, stopwords("english")) # stopwords("english") 영어의 불용어를 의미하며 이를 제거한다
data_corpus <- tm_map(data_corpus, stemDocument) # 어근 추출 

wordcloud(data_corpus, max.words = 100, random.order = F)

# TF-IDF
TDM <- TermDocumentMatrix(data_corpus, control = list(minWordLength = 1)) # minWordLength = 1 은 단어 하나로 구성된 것부터 시작한다는 의미이다 
inspect(TDM[1:10, 1:10])

TFIDF <- weightTfIdf(TDM, normalize = FALSE) # normalize는 정규화 즉 비율로 보겠다는 의미이다
inspect(TFIDF[1:10, 1:10])
findFreqTerms(TDM, lowfreq = 10) # 10회 이상 나온 단어 추출 
findAssocs(TDM, "type", 0.2) # 특정 단어(type)과 상관관계 0.2이상인 단어 추출 

