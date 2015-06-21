
normalize <- function (x, m){
  
  result <- list()
  alfa <- 0
  omega <- 1
  
  for (col in names(x)){
    
    if (missing(m)){
      minval <- min(x[[col]])
      maxval <- max(x[[col]])
    } else {
      minval <- m[[paste(col,".min",sep="")]]
      maxval <- m[[paste(col,".max",sep="")]]
    }
    
    newcol <- apply(cbind(x[[col]]), 1, function(y) (y - minval) / (maxval - minval) * (omega - alfa) + alfa)
    result[[col]] <- newcol
  }
  return(data.frame(result))
}

denormalize <- function (x, m){
  
  result <- list()
  alfa <- 0
  omega <- 1
  
  for (col in names(x)){
    
    minval <- m[[paste(col,".min",sep="")]]
    maxval <- m[[paste(col,".max",sep="")]]
    
    newcol <- apply(cbind(x[[col]]), 1, function(y) (y - alfa) / (omega - alfa) * (maxval - minval) + minval)
    
    result[[col]] <- newcol
  }
  return(data.frame(result))  
}

minmax <- function (x){
  
  result <- list()
  
  for (col in names(x)){
    
    result[[paste(col,"min")]] <- min(x[[col]])
    result[[paste(col,"max")]] <- max(x[[col]])
  }  
  return(data.frame(result))  
}


# returns string w/o leading whitespace
trim.leading <- function (x)  sub("^\\s+", "", x)

# returns string w/o trailing whitespace
trim.trailing <- function (x) sub("\\s+$", "", x)

# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

