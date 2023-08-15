calc_riskPref <-function(sim_data){
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
  riskPref_df <- data.frame(trialNum, risk_LL, risk_HH);
  return(riskPref_df);
}