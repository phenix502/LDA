song.two <- output$songLyric[1:2]
## 分词
song.two <- lapply(song.two, removeEnglish)
song.two <- lapply(song.two,segmentCN)

cor.beta <- Corpus(VectorSource(song.two))

inspect(cor.beta)

##必须出现5次
cor.beta.dtm <- DocumentTermMatrix(cor.beta, control=list( wordLengths = c(2, Inf),stopwords=mystopwords,weighting = weightTfIdf
                                                           minDocFreq=5))

inspect(cor.beta.dtm)