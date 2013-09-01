#加载包
library(RMongo)
library(tm)
library(topicmodels)
library(Rwordseg)
library(wordcloud)
library(igraph)

#connect with database named mydb
mongo<-mongoDbConnect("mydb","localhost",27017)

output <- dbGetQuery(mongo, 'song', "")

##取前面两首歌分析
song <- output$songLyric
## 分词


##删除英语
removeEnglish <- function(x){
  gsub("[a-z]+|[A-Z]+","",x)
}
song <- lapply(song, removeEnglish)
##分词
word <- lapply(song,segmentCN)
##形成语料库
cor <- Corpus(VectorSource(word))
## 文档-词矩阵 词的长度大于1就纳入矩阵  TFIDF
mystopwords <- readLines("stopwords.txt")
cor.dtm <- DocumentTermMatrix(cor, control=list( wordLengths = c(1, Inf),stopwords=mystopwords,weighting = weightTfIdf))
##去掉稀疏矩阵中低频率的词
cor.dtm <- removeSparseTerms(cor.dtm, 0.99)
## 使得每一行至少有一个词不为0
rowTotals <- apply(cor.dtm, 1, sum)
cor.dtm <- cor.dtm[rowTotals > 0]


findFreqTerms(cor.dtm, 5)

#词云分析

m <- as.matrix(t(cor.dtm))
wordFreq <- sort(rowSums(m), decreasing=TRUE)
wordcloud(words = names(wordFreq),freq = wordFreq,
          random.order = F, colors = brewer.pal(8, "Dark2"))

#聚类

# 社会网络分析
Tdtm <- t(dtm)
mdtm <- as.matrix(Tdtm)
mdtm[mdtm>-1]<- 1
termMatrix <- mdtm %*% t(mdtm)

g <- graph.adjacency(termMatrix, weighted=T, mode = 'undirected')
g <- simplify(g)

V(g)$label <- V(g)$name
V(g)$degreee <- degree(g)
set.seed(3952)
layout1 <- layout.fruchterman.reingold(g)
tkplot(g, layout=layout1)










