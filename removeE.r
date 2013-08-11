##删除英语
removeEnglish <- function(x){
  gsub("[a-z]+|[A-Z]+","",x)
  
}