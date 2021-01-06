state = "TX"
outcome = "heart failure"
num = "4"

library(dplyr)
rankhospital <- function(state, outcome, num = "best") {
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

  # Order by name: 
  ## It may occur that multiple hospitals have the same 30-day mortality rate for a given causeof death.  In those cases ties should be broken by using the hospital name
  ooc_state <- ooc_state %>% as.data.frame %>% arrange(ooc_state$Hospital.Name)
  
  # Add a rank column - break ties based on order (that we arranged on name above)
  ooc_state$Rank = rank(ooc_state[selectionColumn], ties.method= "first")

  if (num == "best") num = 1
  if (num == "worst") num = nrow(ooc_state)

  if (is.numeric(x=num) && num > nrow(ooc_state)){
    return(NA)
  }
  
  # Get all relevant hospitals
  match <- ooc_state[(ooc_state[, "Rank"] == num), ]
  
  
  # Return only the first hospital name
  result <- head(match, 1)$Hospital.Name
  
  return (result)
}



#> source("rankhospital.R")> 
rankhospital("TX", "heart failure", 4)
#[1] "DETAR HOSPITAL NAVARRO"> 
rankhospital("MD", "heart attack", "worst")
#3 # [1] "HARFORD MEMORIAL HOSPITAL"> 
rankhospital("MN", "heart attack", 5000)
#[1]  na

