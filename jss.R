# 获取数据
install.packages("corpus.JSS.papers",repos = "http://datacube.wu.ac.at/",
                 type = "source")
data("JSS_papers", package = "corpus.JSS.papers")

set.seed(1102)
library("tm")
library("topicmodels")
library("XML")


remove_HTML_markup <- function(s) {
  doc <- htmlTreeParse(s, asText = TRUE, trim = FALSE)
  iconv(xmlValue(xmlRoot(doc)), "", "UTF-8")
}

corpus <- Corpus(VectorSource(sapply(JSS_papers[, "description"],
                                     remove_HTML_markup)))

dtm <- DocumentTermMatrix(corpus,control = list(stemming = TRUE, stopwords = TRUE, minWordLength = 3,
                                                removeNumbers = TRUE))

dtm <- removeSparseTerms(dtm, 0.99)
dim(dtm)

jss_LDA <- LDA(dtm[1:250,],control = list(alpha = 0.1), k = 10)
jss_CTM <- CTM(dtm[1:250], k = 10)

post <- posterior(jss_LDA, newdata = dtm[-c(1:250),])
round(post$topics[1:5,],digits = 2)
get_terms(jss_LDA, 5)


