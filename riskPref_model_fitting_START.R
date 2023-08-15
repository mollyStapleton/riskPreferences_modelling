##################################
### MODEL FITTING - RISK PREFERENCES ~ RW MODEL 
#######################################################
#### DATA NEEDED:
#### > stimulus choice (t)
#### > reward receivved (t)
#### > stimulus L (t)
#### > stimulus R (t)

rm(list = ls());
setwd(dirname(getwd()));
source("~/GitHub/riskPreferences_modelling/utilities/reward_sum.R");
source("~/GitHub/riskPreferences_modelling/RW/sim_riskPref_RW.R")
source("~/GitHub/riskPreferences_modelling/riskPreference_utilities/calc_riskPref.R")
source("~/GitHub/riskPreferences_modelling/riskPreference_utilities/plot_riskPref.R")
library(ggplot2);
library(nloptr);

# load in .csv behavioural file to retrieve single participant data 
dataIn <- read.csv("~/GitHub/riskPreferences_modelling/data/allTr_allSubjects.csv", header = FALSE, sep = ',');
colnames(dataIn) <- c("subIdx", "gender", "blockNum", "trialNum", "distType", 'stimL', 'stimR', 'chosenDir', 'stimChoice',
                    'cndIdx', 'choiceHigh', 'choiceRisky', 'stimCombo', 'RT', 'reward');

# for now we will try model fitting with only a single subject 
subIdx  <- (dataIn$subIdx == 30);

# retrieve all relevant data
dat    <- data.frame(dataIn$subIdx[subIdx], dataIn$blockNum[subIdx], dataIn$trialNum[subIdx], dataIn$distType[subIdx],
                     dataIn$stimL[subIdx], dataIn$stimR[subIdx], dataIn$stimChoice[subIdx], dataIn$stimCombo[subIdx],
                     dataIn$reward[subIdx]);

colnames(dat) <- c("subIdx", 'blockNum', "trialNum", "distType", 'stimL', 'stimR', 'stimChoice', 'stimCombo', 'reward');

# initialise vector of parameters to test
# priors taken from Moeller et al., 2021
# logit(alpha) N ~ (-1, 2)
# log(beta) N ~ (-2 2)

nFits = 500;
alpha <- dlogis(rnorm(nFits, mean = -1, sd = 2));
beta  <- exp(rnorm(nFits, mean = -2, sd = 2));

# defining the objective function, taking the data and applying the RW algorithms 
# identify Gaussian reward trials (again this is just to start)
distIdx <- (dat$distType == 1)
# retrieve all relevant data
dat    <- data.frame(dat$subIdx[distIdx], dat$blockNum[distIdx], dat$trialNum[distIdx], dat$distType[distIdx],
                     dat$stimL[distIdx], dat$stimR[distIdx], dat$stimChoice[distIdx], dat$stimCombo[distIdx], dat$reward[distIdx]);
colnames(dat) <- c("subIdx", 'blockNum', "trialNum", "distType", 'stimL', 'stimR', 'stimChoice', 'stimCombo','reward');

Qt    <- c(50, 50, 50, 50);
negLL <- c();

for (iter in 1: nFits){
  
  Q             <- c();    # store updated Q values
  choiceBinary  <- matrix(nrow = 1, ncol= length(dat[,1]));    # store choices made to L as vector of [0 = right, 1 = left]
  choiceType    <- matrix(nrow = 1, ncol= length(dat[,1]));
  choiceProb    <- matrix(nrow = 1, ncol= length(dat[,1]));    # store probabilities assigned to choices
  
  stimL_total   <- c();
  stimR_total   <- c();
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
      choiceProb[t] <- p[t] ;
    if (stimL[t] == stimChoiceIdx[t]){
      choiceBinary[t] <- 1;
    }
    if (stimR[t] == stimChoiceIdx[t]){
      choiceBinary[t] <- 0;
    }
    if (stimChoiceIdx[t] == 2){
      choiceType[t] <- -1;
      }
    if (stimChoiceIdx[t] == 4){
      choiceType[t] <- 1;
    }
    # only retain running sum of LL and HH trial stimulus presentations
    stimL_total[t] = stimL[t];
    stimR_total[t] = stimR[t];
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


