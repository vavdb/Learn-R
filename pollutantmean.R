library(dplyr)
pollutantmean <- function(directory, pollutant, id = 1:332)
{  
  
  # Change Id to files as ###.csv
  filenames <- sprintf("%03d.csv", id)
  # Read each file, after building the path and passing it to read.csv
  filesdata <- lapply(filenames, 
                      function(file) {
                        read.csv(file.path(directory, file))
                      })
  # Bind all rows to a single set
  data <- bind_rows(filesdata)
  # Get the mean of the requested pollutant
  return(mean(data[[pollutant]], na.rm = TRUE))
}