rm(list = ls())
setwd(dirname(getwd()))

##########################################
#----reward simulation function 
##########################################

source("~/GitHub/riskPreferences_modelling/reward_sum.R");
source("~/GitHub/riskPreferences_modelling/sim_riskPref_RW.R")
source("~/GitHub/riskPreferences_modelling/calc_riskPref.R")
library(ggplot2);

# START SCRIPT TO RUN MODEL SIMULATIONS 
# MODEL OF CHOICE (parameters to estimate):

# - RESCORLA WAGNER               (Q0, alpha, beta)
# - +VE/-VE RATES                 (Q0, alphaPos, alphaNeg, beta) 
# - UPPER CONFIDENCE BOUND        (Q0, conf, alpha, beta)
# - PEIRS                         (Q0, S0, alphaQ, alphaS, beta, omega)


nIters <- 1000; # simulate 1000 blocks
Qt     <- c(50, 50, 50, 50); #consistent across all four models 

stimulusCombinations <- c(12,13,14,21,23,24,31,32,34,41,42,43); #stimulus idx combinations

# Set some parameters for model simulations 
alpha <- 0.15
beta  <- 0.3;

dist = 'gauss';

#Run simulation of data using RW model

sim_data <- sim_riskPref_RW(dist, alpha, beta);

# CALCULATE RISK PREFERENCES
# TrialType: 0 = different-mean; 1 = matched-mean
# ChoiceType: -1 = LL-risky; 1 = HH-risky;

riskPref_df <- calc_riskPref(sim_data){
risk_LL <- c(); risk_HH <-c();
totalStim_LL<-c(); totalStim_HH<-c()
for (itrial in 1:120){
    
    totalStim_LL[itrial] <- c(sum(sim_data$stimL_total[,itrial] == 2, na.rm = TRUE) + sum(sim_data$stimR_total[,itrial] == 2, na.rm = TRUE))
    risk_LL[itrial] = c(sum(sim_data$choiceType[, itrial] == -1, na.rm = TRUE)/totalStim_LL[itrial]);
    
}
for (itrial in 1:120){
  
  totalStim_HH[itrial] <- c(sum(sim_data$stimL_total[,itrial] == 4, na.rm = TRUE) + sum(sim_data$stimR_total[,itrial] == 4, na.rm = TRUE))
  risk_HH[itrial] = c(sum(sim_data$choiceType[, itrial] == 1, na.rm = TRUE)/totalStim_HH[itrial]);
}

trialNum    <-c(1:120);
riskPref_df <- data.frame(trialNum, risk_LL, risk_HH)
}

#PLOT RISK PREFERENCES 
lightpurple <- rgb(0.83, 0.71, 0.98);
darkpurple <- rgb(0.62, 0.35, 0.99);
lightgreen <- rgb(0.58, 0.99, 0.56); 
darkgreen  <- rgb(0.19, 0.62, 0.14); 

# plot binned over trials 
bin <- c(1, 25, 49, 73, 97);
binSize <-24;
meanLL<-c();meanHH<-c();
stdLL<-c(); stdHH<-c();

for (ibin in 1: length(bin)){
  
  meanLL[ibin] <- mean(risk_LL[c(bin[ibin]) : c(bin[ibin] + binSize -1)]);
  stdLL[ibin] <- sd(risk_LL[c(bin[ibin]) : c(bin[ibin] + binSize -1)])/sqrt(length(risk_LL[c(bin[ibin]) : c(bin[ibin] + binSize -1)]));
  meanHH[ibin] <- mean(risk_HH[c(bin[ibin]) : c(bin[ibin] + binSize -1)]);
  stdHH[ibin] <- sd(risk_HH[c(bin[ibin]) : c(bin[ibin] + binSize -1)])/sqrt(length(risk_HH[c(bin[ibin]) : c(bin[ibin] + binSize -1)]));
  
}

trialBin <- c(1:5);
df <- data.frame(trialBin, meanLL, stdLL, meanHH, stdHH)
  
riskPref <- ggplot(df, aes(x = trialBin))+
  geom_line(aes(y = meanLL), color=lightpurple, size= 1)+
    geom_line(aes(y = meanHH), color=darkpurple, size= 1)+
      geom_errorbar(aes(ymin = meanLL- stdLL, ymax = meanLL+stdLL),color=lightpurple, width=1.2)+
        geom_errorbar(aes(ymin = meanHH- stdHH, ymax = meanHH+stdHH),color=darkpurple, width=1.2)+
          ylim(0, 0.7)+
            theme_classic()+
              ylab('P(Risky)')
                print(riskPref);
  