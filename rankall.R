outcome = "heart attack"
num = 20

library(dplyr)
rankall <- function(outcome, num = "best") {
  ooc <-
    read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
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
  
  result <- list()
  
  
  for (state in unique(sort(ooc$State)))
  {
    # Get only the requested state
    ooc_state <- ooc[ooc$State == state,]
    
    # Make the relevant column numeric
    ooc_state[, selectionColumn] <-
      suppressWarnings(as.numeric(ooc_state[, selectionColumn]))
    
    # Remove NA values
    ooc_state = na.omit(ooc_state)
    
    # Order by name:
    ## It may occur that multiple hospitals have the same 30-day mortality rate for a given causeof death.  In those cases ties should be broken by using the hospital name
    ooc_state <-
      ooc_state %>% as.data.frame %>% arrange(ooc_state$Hospital.Name)
    
    # Add a rank column - break ties based on order (that we arranged on name above)
    ooc_state$Rank = rank(ooc_state[selectionColumn], ties.method = "first")
    
    
    if (num == "worst")
    {
      n = nrow(ooc_state)
    }
    else if (num == "best")
    {
      n = 1
    }
    else {
      n = num
    }
    
    # Get all relevant hospitals
    match <- ooc_state[(ooc_state[, "Rank"] == n),]

    if (n > nrow(ooc_state))
    {
      result <- rbind(result, c(NA, state))
    } else {
      # Return only the first hospital name
      result <- rbind(result, c(head(match, 1)$Hospital.Name, state))
    }
  
        
  }
  colnames(result) <- c('hospital', 'state')
  return (result %>% as.data.frame())
}



head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)
