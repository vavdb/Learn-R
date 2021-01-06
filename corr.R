library(dplyr)
source("complete.R")
corr <- function(directory, threshold = 0)
{  
  # If no monitors meet the threshold requirement, then the function should return a numeric vector of length 0
  results <- numeric(0)
  
  # Grab the complete cases from the complete function
  complete_cases <- complete(directory)
  complete_cases_treshold <- complete_cases[complete_cases$nobs>=threshold, ]
  

  # Read each monitor
  for (monitor in complete_cases_treshold$id) {
    data <- read.csv(file.path(directory, sprintf("%03d.csv", monitor)))
    data <- na.omit(data)
    
    # Append the correlations
    results = c(results, cor(data$sulfate, data$nitrate))
  }
  
  return(results)
}
