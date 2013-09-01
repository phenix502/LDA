JJ  <- Corpus(DirSource("JJ"), encoding = "UTF-8",
              readerControl = list(reader = readPlain, language = "cn"))

# 分词后为列表
JJ <- lapply(JJ, function(x) unlist(segmentCN(x)))
# 再组合成语料库
temp <- Corpus(VectorSource(JJ), encoding = "UTF-8", 
               readerControl = list(reader = readPlain, language = "cn"))

removeURL <- function(x) {
  gsub("http[[:alum:]]*", "", x)
}

##删除英语
removeEnglish <- function(x){
  gsub("[a-z]+|[A-Z]+","",x)
  
}
temp <- tm_map(temp, removeURL)
temp <- tm_map(temp, removeEnglish)
temp <- tm_map(temp, stripWhitespace)

## 加载停止词
mystopwords <- readLines("stopwords.txt")
dtm <- DocumentTermMatrix(temp,control=list( wordLengths = c(1, Inf),stopwords=mystopwords,weighting = weightTfIdf))
inspect(dtm)

dtm <- removeSparseTerms(dtm, 0.83)
findFreqTerms(dtm, 1)









