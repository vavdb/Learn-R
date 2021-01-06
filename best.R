library(dplyr)
best <- function(state, outcome) {
  ooc <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  ## Read outcome data
  ## Check that state and outcome are valid
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  
  # The outcomes can be one of “heart attack”, “heart failure”, or “pneumonia”
  if (outcome == "heart attack") { 
    selectionColumn = 11 #"Hospital 30-Day Death (Mortality) Rates from Heart Attack"
  } else if (outcome == "heart failure") {
    selectionColumn = 17 #"Hospital 30-Day Death (Mortality) Rates from Heart Failure"
  } else if (outcome == "pneumonia") {
    selectionColumn = 23 #"Hospital 30-Day Death (Mortality) Rates from Pneumonia"
  } else {
    stop("invalid outcome")
  }

  if (!any(state == ooc$State)){
    stop("invalid state")     
  }  

  # Get only the requested state
  ooc_state <- ooc[ooc$State == state, ]
  
  # Make the relevant column numeric
  ooc_state[, selectionColumn] <- suppressWarnings(as.numeric(ooc_state[, selectionColumn]))
  
  # Remove NA values
  ooc_state = na.omit(ooc_state)
  
  # Get the lowest value
  lowest_rate <- min(na.omit(ooc_state[selectionColumn]))
  
  # Get all relevant hospitals
  best_hospitals <- ooc_state[(ooc_state[, selectionColumn] == lowest_rate), ]
  best_hospitals <- best_hospitals %>% as.data.frame %>% arrange("Hospital.Name")
  
  # Return only the first hospital name
  best_hospital <- head(best_hospitals, 1)$Hospital.Name
  
  return (best_hospital)
}
