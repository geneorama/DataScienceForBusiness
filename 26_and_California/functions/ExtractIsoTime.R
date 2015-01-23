##==============================================================================
## Function to convert string date / time to ISO date / time
##==============================================================================

## 000000000111111111122
## 123456789012345678901
## 2012-12-30T20:57:19.616186

ExtractIsoTime = function(x) {
	# browser()}
	iso_time = ISOdatetime(
		year    = as.numeric(substr(x, 1, 4)), 
		month   = as.numeric(substr(x, 6, 7)), 
		day     = as.numeric(substr(x, 9, 10)),
		hour    = as.numeric(substr(x, 12, 13)), 
		min     = as.numeric(substr(x, 15, 16)), 
		sec     = as.numeric(substr(x, 18, 99)))
	return(iso_time)
}

## Test function:
# ExtractIsoTime(c("12/09/20 12:42:55.35", "12/09/20 12:42:55.69"))
# ExtractIsoTime(c("12/09/20 12:42:55.355", "12/09/20 12:42:55.694"))
# ExtractIsoTime(c("12/09/20 12:42:55.355", "12/09/20 12:42:55.694"), 21)
# ExtractIsoTime(c("12/09/20 12:42:55.355", "12/09/20 12:42:55.694"), 20)
# ExtractIsoTime(c("0/00/00 00:00:16.18", "0/00/00 00:00:16.43"))
# ExtractIsoTime(c("0/00/00 00:00:16.18", "0/00/00 00:00:16.43"), 20)













