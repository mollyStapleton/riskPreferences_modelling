##################################
### MODEL FITTING - RISK PREFERENCES ~ RW MODEL 
#######################################################
#### Author: M. Stapleton, August 2023 #################
################################################################

#### DATA NEEDED:
#### > stimulus choice (t)
#### > reward receivved (t)
#### > stimulus L (t)
#### > stimulus R (t)

rm(list = ls());
setwd(dirname(getwd()));
source("~/GitHub/riskPreferences_modelling/utilities/reward_sum.R");
source("~/GitHub/riskPreferences_modelling/RW/sim_riskPref_RW.R");
source("~/GitHub/riskPreferences_modelling/RW/fit_riskPref_RW.R");
source("~/GitHub/riskPreferences_modelling/riskPreference_utilities/calc_riskPref.R");
source("~/GitHub/riskPreferences_modelling/riskPreference_utilities/plot_riskPref.R");
library(ggplot2);
library(nloptr);

# identify Gaussian reward trials (again this is just to start)
dist2run <- c(1); #   1= Gauss; 2 = Bimodal

# load in .csv behavioural file to retrieve single participant data 
dataIn <- read.csv("~/GitHub/riskPreferences_modelling/data/allTr_allSubjects.csv", header = FALSE, sep = ',');
colnames(dataIn) <- c("subIdx", "gender", "blockNum", "trialNum", "distType", 'stimL', 'stimR', 'chosenDir', 'stimChoice',
                    'cndIdx', 'choiceHigh', 'choiceRisky', 'stimCombo', 'RT', 'reward');

# for now we will try model fitting with only a single subject 
subIdx <- unique(dataIn$subIdx);
parameterFits <- matrix(nrow = (length(subIdx)*(length(dist2run))), ncol = 3);

for (isubject in 1: length(subIdx)){
  
  sub2run  <- (dataIn$subIdx == subIdx[isubject]);
  dat      <- c();
  # retrieve all relevant data
  dat    <- data.frame(dataIn$subIdx[sub2run], dataIn$blockNum[sub2run], dataIn$trialNum[sub2run], dataIn$distType[sub2run],
                       dataIn$stimL[sub2run], dataIn$stimR[sub2run], dataIn$stimChoice[sub2run], dataIn$stimCombo[sub2run],
                       dataIn$reward[sub2run]);
  
  colnames(dat) <- c("subIdx", 'blockNum', "trialNum", "distType", 'stimL', 'stimR', 'stimChoice', 'stimCombo', 'reward');
  
  # initialise vector of parameters to test
  # priors taken from Moeller et al., 2021
  # logit(alpha) N ~ (-1, 2)
  # log(beta) N ~ (-2 2)
  
  nFits <- 1000;
  alpha <- dlogis(rnorm(nFits, mean = -1, sd = 2));
  beta  <- exp(rnorm(nFits, mean = -2, sd = 2));
  Qt    <- c(50, 50, 50, 50);
  negLL <- c();
  
  for (idist in 1: length(dist2run)){
    
    distIdx <-  c();
    distIdx < - (dat$distType == dist2run[idist]);
    
    # retrieve all relevant data
    dat    <- data.frame(dat$subIdx[distIdx], dat$blockNum[distIdx], dat$trialNum[distIdx], dat$distType[distIdx],
                         dat$stimL[distIdx], dat$stimR[distIdx], dat$stimChoice[distIdx], dat$stimCombo[distIdx], dat$reward[distIdx]);
    colnames(dat) <- c("subIdx", 'blockNum', "trialNum", "distType", 'stimL', 'stimR', 'stimChoice', 'stimCombo','reward');
    
    # defining the objective function, taking the data and applying the RW algorithms
    
    # fit_riskPref_RW <- function(dat, alpha, beta){
      
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
      
    #   outputList <- list(negLL[best], alphaBest, betaBest, BIC);
    #   names(outputList) <- c('NegLL', 'alpha_fit', 'beta_fit', 'BIC');
    #   return(outputList);
    # } 
    
    # bestFit <- fit_riskPref_RW(dat, alpha, beta);
    parameterFits[isubject*distIdx, 1] = subIdx[isubject];
    paramterFits[isubject*distIdx, 2]  = bestFit$alpha;
    paramterFits[isubject*distIdx, 3]  = bestFit$beta;
  }
}
  




