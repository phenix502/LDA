library(Rwordseg)
## 本函数主要是读取文档，然后对文档进行分词。

for (i in 1:400){
  file.path <- paste("~/code/jss/clothe/", i, ".txt", sep = "")
  txt <- readLines(file.path, encoding = 'utf-8')
  ## 去掉空白行
  txt = txt[txt!=" "]
  ## 分词
  words = unlist(lapply(txt,segmentCN))
  
  file.save <- paste("corpus/", i, ".txt", sep = "")
  write.table(words, file.save, fileEncoding = 'utf-8')
}