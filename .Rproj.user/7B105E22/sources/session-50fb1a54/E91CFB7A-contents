rm(list = ls())
setwd(dirname(getwd()))

##########################################
#----reward simulation function 
##########################################

source("~/GitHub/riskPreferences_modelling/utilities/reward_sum.R");
source("~/GitHub/riskPreferences_modelling/RW/sim_riskPref_RW.R")
source("~/GitHub/riskPreferences_modelling/riskPreference_utilities/calc_riskPref.R")
source("~/GitHub/riskPreferences_modelling/riskPreference_utilities/plot_riskPref.R")
library(ggplot2);

# START SCRIPT TO RUN MODEL SIMULATIONS 
# MODEL OF CHOICE (parameters to estimate):

# - RESCORLA WAGNER               (Q0, alpha, beta)
# - +VE/-VE RATES                 (Q0, alphaPos, alphaNeg, beta) 
# - UPPER CONFIDENCE BOUND        (Q0, conf, alpha, beta)
# - PEIRS                         (Q0, S0, alphaQ, alphaS, beta, omega)

dist   <- c('bimodal');
nIters <- 1000; # simulate 1000 blocks
Qt     <- c(50, 50, 50, 50); #consistent across all four models 

# Set some parameters for model simulations 
alpha <- 0.15
beta  <- 0.3;

# plot binned over trials 
bin <- c(1, 25, 49, 73, 97);
binSize <-24;
meanLL<-matrix(nrow = length(bin), ncol = length(dist));meanHH<-matrix(nrow = length(bin), ncol = length(dist));
stdLL<-matrix(nrow = length(bin), ncol = length(dist)); stdHH<-matrix(nrow = length(bin), ncol = length(dist));

#Run simulation of data using RW model
for (idist in 1: length(dist)){

  sim_data <- sim_riskPref_RW(dist[idist], alpha, beta);

    # CALCULATE RISK PREFERENCES
    # TrialType: 0 = different-mean; 1 = matched-mean
    # ChoiceType: -1 = LL-risky; 1 = HH-risky;

    riskPref_df <- calc_riskPref(sim_data);

    #
    # #PLOT RISK PREFERENCES
    # #select distribution specific colour scheme
    if (dist[idist] == 'gauss'){
      LL <- rgb(0.83, 0.71, 0.98);
      HH <- rgb(0.62, 0.35, 0.99);
      } else {
      LL <- rgb(0.58, 0.99, 0.56);
      HH  <- rgb(0.19, 0.62, 0.14);
      }
    #
    #
    for (ibin in 1: length(bin)){

      meanLL[ibin, idist] <- mean(riskPref_df$risk_LL[c(bin[ibin]) : c(bin[ibin] + binSize -1)]);
      stdLL[ibin, idist] <- sd(riskPref_df$risk_LL[c(bin[ibin]) : c(bin[ibin] + binSize -1)])/sqrt(length(riskPref_df$risk_LL[c(bin[ibin]) : c(bin[ibin] + binSize -1)]));
      meanHH[ibin, idist] <- mean(riskPref_df$risk_HH[c(bin[ibin]) : c(bin[ibin] + binSize -1)]);
      stdHH[ibin, idist] <- sd(riskPref_df$risk_HH[c(bin[ibin]) : c(bin[ibin] + binSize -1)])/sqrt(length(riskPref_df$risk_HH[c(bin[ibin]) : c(bin[ibin] + binSize -1)]));

    }
    #
    trialBin <- c(1:5);
    df <- c();
    df <- data.frame(trialBin, meanLL[, idist], stdLL[, idist], meanHH[, idist], stdHH[, idist])
    colnames(df) <- c('trialBin', 'meanLL', 'stdLL', 'meanHH', 'stdHH')

      riskPref <- ggplot(df, aes(x = trialBin))+
        geom_line(aes(y = meanLL), color=LL, size= 1)+
        geom_line(aes(y = meanHH), color=HH, size= 1)+
        geom_errorbar(aes(ymin = meanLL- stdLL, ymax = meanLL+stdLL),color=LL, width=1.2)+
        geom_errorbar(aes(ymin = meanHH- stdHH, ymax = meanHH+stdHH),color=HH, width=1.2)+
        ylim(0, 0.7)+
        theme_classic()+
        ylab('P(Risky)')

    print(riskPref)

    }