rm(list = ls())
setwd(dirname(getwd()))

##########################################
#----reward simulation function 
##########################################

source("~/GitHub/riskPreferences_modelling/reward_sum.R");
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

trialType<-matrix(nrow=nIters, ncol= 120); choiceType<- matrix(nrow=nIters, ncol= 120);
stimL_total<-matrix(nrow=nIters, ncol= 120); stimR_total<-matrix(nrow=nIters, ncol= 120);

# SIMULATE OUR REWARD DISTRIBUTIONS 
# generate GAUSSIAN
for (i in 1: nIters){

  R <- 0;
  R <- reward_sum('gauss');
  
  stimuliShown <- c();
  # DETERMINE ORDER OF STIMULUS PRESENTATION
  for (istim in 1:12){
    tmpRnd <- stimulusCombinations[sample(1:10)];
    stimuliShown <- c(stimuliShown, tmpRnd);
  }
  stim_L <- floor(stimuliShown/10);
  stim_R <- stimuliShown - floor(stimuliShown/10)*10;
  
  p <- c(); v<- c(); stimChoice<- c(); delta<- c();stimIdx<-c(); stimCount<-c(0, 0, 0, 0);
  
  #LOOP OVER INDIVIDUAL TRIALS 
  for (itrial in 1:120){
    
    # select stimuli shown (t)
    stim_tL <- stim_L[itrial];
    stim_tR <- stim_R[itrial];
    
    
    # softmax to determine choice (t)
    v <- c(beta*Qt[stim_tL], beta*Qt[stim_tR]);
    p  <- exp(v - max(v))/ sum(exp(v - max(v)));
    
    # generate binary vector of choices made to L stimulus
    if (p[1] > runif(1, 0, 1)){
      stimChoice[itrial] = 1;
      stimIdx            = stim_tL;
      stimCount[stimIdx] = stimCount[stimIdx] +1;
      } else {
      stimChoice[itrial] = 0;
      stimIdx            = stim_tR;
      stimCount[stimIdx] = stimCount[stimIdx] +1;}
            
      #if matched-mean condition
      #use indices to calculate risk preferences
      if (stimuliShown[itrial] == 12 | stimuliShown[itrial] == 34 | stimuliShown[itrial] == 21| stimuliShown[itrial] == 43){ 
         trialType[i, itrial] <- 1;
        if (stimIdx == 2){
          choiceType[i, itrial] <- -1 # LL- Risky Choice
        } else {
          choiceType[i, itrial] <- 1  # HH - Risky Choice
        }
      }
  
      # updating Q values according to delta rule 
      delta[itrial] = R[stimCount[stimIdx], stimIdx] - Qt[stimIdx];
      Qt[stimIdx]   = Qt[stimIdx] + (alpha * delta[itrial]);
      
      stimL_total[i, itrial] = stim_L[itrial];
      stimR_total[i, itrial] = stim_R[itrial];
  }
  
}
    
# CALCULATE RISK PREFERENCES
# TrialType: 0 = different-mean; 1 = matched-mean
# ChoiceType: -1 = LL-risky; 1 = HH-risky;

risk_LL <- c(); risk_HH <-c();
totalStim_LL<-c(); totalStim_HH<-c()
for (itrial in 1:120){
    
    totalStim_LL[itrial] <- c(sum(stimL_total[,itrial] == 2, na.rm = TRUE) + sum(stimR_total[,itrial] == 2, na.rm = TRUE))
    risk_LL[itrial] = c(sum(choiceType[, itrial] == -1, na.rm = TRUE)/totalStim_LL[itrial]);
    
}
for (itrial in 1:120){
  
  totalStim_HH[itrial] <- c(sum(stimL_total[,itrial] == 4, na.rm = TRUE) + sum(stimR_total[,itrial] == 4, na.rm = TRUE))
  risk_HH[itrial] = c(sum(choiceType[, itrial] == 1, na.rm = TRUE)/totalStim_HH[itrial]);
}

trialNum    <-c(1:120);
riskPref_df <- data.frame(trialNum, risk_LL, risk_HH)

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
geom_line(aes(y = meanLL, color=lightpurple, size= 1))+
geom_line(aes(y = meanHH, color=darkpurple, size= 1))+
ylim(0, 1)
print(riskPref)
  