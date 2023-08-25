fit_riskPref_RW <- function(dat, alpha, beta){
  
  choiceBinary  <- matrix(nrow = nFits, ncol= length(dat[,1]));    # store choices made to L as vector of [0 = right, 1 = left]
  choiceType    <- matrix(nrow = nFits, ncol= length(dat[,1]));
  choiceProb    <- matrix(nrow = nFits, ncol= length(dat[,1]));    # store probabilities assigned to choices
  
  stimL_total   <- matrix(nrow = nFits, ncol= length(dat[,1]));
  stimR_total   <- matrix(nrow = nFits, ncol= length(dat[,1]));
  
  for (iter in 1: nFits){
    
    Q             <- c();    # store updated Q values
    stimL         <- c();
    stimR         <- c();
    p             <- c();
    stimChoiceIdx <- c();
    delta         <- c();
    
    for (t in 1: length(dat[,1])){
      # stimuli shown on trial (t)
      stimL[t] <-dat$stimL[t];
      stimR[t] <-dat$stimR[t];
      
      # softmax for probability of choice (t)
      # takes beta parameter from nFit
      p[t]  <- exp(beta[iter]*Qt[stimL[t]])/ (exp(beta[iter]*Qt[stimL[t]]) + exp(beta[iter]*Qt[stimR[t]]));
      
      #stimIdx of choice made on trial (t)
      stimChoiceIdx[t] <- dat$stimChoice[t];
      
      # store probability assigned to choices that occured during matched-mean conditions
      if (dat$stimCombo[t] == 12 | dat$stimCombo[t]  == 34 | dat$stimCombo[t]  == 21| dat$stimCombo[t]  == 43){
        choiceProb[iter, t] <- p[t] ;
        if (stimL[t] == stimChoiceIdx[t]){
          choiceBinary[iter, t] <- 1;
        }
        if (stimR[t] == stimChoiceIdx[t]){
          choiceBinary[iter, t] <- 0;
        }
        if (stimChoiceIdx[t] == 2){
          choiceType[iter, t] <- -1;
        }
        if (stimChoiceIdx[t] == 4){
          choiceType[iter, t] <- 1;
        }
        # only retain running sum of LL and HH trial stimulus presentations
        stimL_total[iter, t] = stimL[t];
        stimR_total[iter, t] = stimR[t];
      }
      
      # updating Q values according to delta rule
      delta[t] = dat$reward[t] - Qt[stimChoiceIdx[t]];
      Qt[stimChoiceIdx[t]]   = Qt[stimChoiceIdx[t]] + (alpha[iter] * delta[t]);
      
      
    }
    
    negLL[iter] = -sum(choiceProb, na.rm = TRUE);
    
  }
  # quantify model fit and identify the best fitting parameters
  best      <- (negLL == min(negLL))
  alphaBest <- alpha[best];
  betaBest  <- beta[best];
  BIC       <- 2 * log(length(dat[,1])) + 2*negLL[best];
  
  outputList <- list(negLL[best], alphaBest, betaBest, BIC);
  names(outputList) <- c('NegLL', 'alpha_fit', 'beta_fit', 'BIC');
  return(outputList);
} 