rm(list = ls())
setwd(dirname(getwd()))

##########################################
#----reward simulation function 
##########################################

source("~/GitHub/riskPreferences_modelling/reward_sum.R");

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


# SIMULATE OUR REWARD DISTRIBUTIONS 
# generate GAUSSIAN
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

    # updating Q values according to delta rule 
    delta[itrial] = R[stimCount[stimIdx], stimIdx] - Qt[stimIdx];
    Qt[stimIdx]   = Qt[stimIdx] + (alpha * delta[itrial]);
}


