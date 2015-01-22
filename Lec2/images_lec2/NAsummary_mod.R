#' @name   NAsummary
#' @title  Summarize NA values in a matrix or data.frame (or data.table)
#' @author Gene Leynes
#' 
#' @param df            A data.frame to be summarized
#' @param include_nan   Do you want to also see Nan's along with NA's
#'                      Defaults to FALSE
#'
#' @description
#' 		Summarize the available information in a data.frame (or similar) quickly

NAsummary <-function(df){
	newdf = data.frame(col=1:ncol(df),
					   Count =nrow(df),
					   nNA = sapply(df,function(x)length(x[is.na(x)])))
	
	newdf$rNA = newdf$nNA / newdf$Count
	newdf$rNA = trunc(newdf$rNA*10000)/10000
	
	newdf$nUnique = sapply(df,function(x)length(unique(x)))
	
	newdf$rUnique = newdf$nUnique / newdf$Count
	newdf$rUnique = trunc(newdf$rUnique*10000)/10000
	
	rownames(newdf) = colnames(df)
	return(newdf)
}

