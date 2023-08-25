sim_riskPref_RW <-function(dist, alpha, beta){

  trialType<-matrix(nrow=nIters, ncol= 120); choiceType<- matrix(nrow=nIters, ncol= 120);
  stimL_total<-matrix(nrow=nIters, ncol= 120); stimR_total<-matrix(nrow=nIters, ncol= 120);

  stimulusCombinations <- c(12,13,14,21,23,24,31,32,34,41,42,43); #stimulus idx combinations
  # LL: 12, 21
  # HH: 34, 43

  for (i in 1: nIters){

    # SIMULATE OUR REWARD DISTRIBUTIONS
    R <- 0;
    R <- reward_sum(dist);

    stimuliShown <- c();
    # DETERMINE ORDER OF STIMULUS PRESENTATION
    for (istim in 1:10){
      tmpRnd <- stimulusCombinations[sample(1:12)];
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

      # prob <- exp(beta * Qt[stim_tL, t - 1]) / (exp(beta * Q[opts[1], t - 1]) + exp(beta * Q[opts[2], t - 1]))
      # # softmax to determine choice (t)
      v <- c(beta*Qt[stim_tL], beta*Qt[stim_tR]);
      p  <- exp(beta*Qt[stim_tL])/ (exp(beta*Qt[stim_tL]) + exp(beta*Qt[stim_tR]));

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
        } 
        if (stimIdx == 4){
          choiceType[i, itrial] <- 1  # HH - Risky Choice
        }
        # only retain running sum of LL and HH trial stimulus presentations
        stimL_total[i, itrial] = stim_L[itrial];
        stimR_total[i, itrial] = stim_R[itrial];
      }

      # updating Q values according to delta rule
      delta[itrial] = R[stimCount[stimIdx], stimIdx] - Qt[stimIdx];
      Qt[stimIdx]   = Qt[stimIdx] + (alpha * delta[itrial]);


    }

    }
  
  outputList <- list(choiceType, stimL_total,stimR_total);
  names(outputList) <- c("choiceType", "stimL_total", "stimR_total");
  return(outputList);
}  