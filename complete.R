library(dplyr)
complete <- function(directory, id = 1:332)
{  

  # Create dataframe with header
  results <- data.frame(id=numeric(0), nobs=numeric(0))
  
  # Read each monitor
  for (monitor in id) {
    data <- read.csv(file.path(directory, sprintf("%03d.csv", monitor)))
    
    # Remove na data
    data <- na.omit(data)
    
    # Append result tot data frame, id is the monitor and the row count is nobs
    results <- rbind(results, data.frame(id = monitor, nobs = nrow(data)))
  }
  
  return(results)
}
