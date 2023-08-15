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
source("~/GitHub/riskPreferences_modelling/RW/sim_riskPref_RW.R");
source("~/GitHub/riskPreferences_modelling/RW/fit_riskPref_RW.R");
source("~/GitHub/riskPreferences_modelling/riskPreference_utilities/calc_riskPref.R");
source("~/GitHub/riskPreferences_modelling/riskPreference_utilities/plot_riskPref.R");
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

nFits = 1000;
alpha <- dlogis(rnorm(nFits, mean = -1, sd = 2));
beta  <- exp(rnorm(nFits, mean = -2, sd = 2));
Qt    <- c(50, 50, 50, 50);
negLL <- c();

# identify Gaussian reward trials (again this is just to start)
distIdx <- (dat$distType == 1)
# retrieve all relevant data
dat    <- data.frame(dat$subIdx[distIdx], dat$blockNum[distIdx], dat$trialNum[distIdx], dat$distType[distIdx],
                     dat$stimL[distIdx], dat$stimR[distIdx], dat$stimChoice[distIdx], dat$stimCombo[distIdx], dat$reward[distIdx]);
colnames(dat) <- c("subIdx", 'blockNum', "trialNum", "distType", 'stimL', 'stimR', 'stimChoice', 'stimCombo','reward');


# defining the objective function, taking the data and applying the RW algorithms
bestFit <- fit_riskPref_RW(dat, alpha, beta);


  




