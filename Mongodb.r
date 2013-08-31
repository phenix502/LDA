#加载包
library(RMongo)
library(tm)
library(topicmodels)
library(Rwordseg)

#connect with database named mydb
mongo<-mongoDbConnect("mydb","localhost",27017)

output <- dbGetQuery(mongo, 'song', "")
##取前面两首歌分析
song <- output$songLyric
## 分词
song <- lapply(song, removeEnglish)
word <- lapply(song,segmentCN)
##形成语料库
cor <- Corpus(VectorSource(word))
## 文档-词矩阵 词的长度大于1就纳入矩阵  TFIDF
cor.dtm <- DocumentTermMatrix(cor, control=list( wordLengths = c(1, Inf),stopwords=mystopwords,weighting = weightTfIdf))
##去掉稀疏矩阵中低频率的词
cor.dtm <- removeSparseTerms(cor.dtm, 0.99)
## 使得每一行至少有一个词不为0
rowTotals <- apply(cor.dtm, 1, sum)
cor.dtm <- cor.dtm[rowTotals > 0]






