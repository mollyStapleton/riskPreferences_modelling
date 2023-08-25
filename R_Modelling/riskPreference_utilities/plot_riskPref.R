plot_riskPref <- function(df, LL, HH){  
  riskPref <- ggplot(df, aes(x = trialBin))+
    geom_line(aes(y = meanLL), color=LL, size= 1)+
    geom_line(aes(y = meanHH), color=HH, size= 1)+
    geom_errorbar(aes(ymin = meanLL- stdLL, ymax = meanLL+stdLL),color=LL, width=1.2)+
    geom_errorbar(aes(ymin = meanHH- stdHH, ymax = meanHH+stdHH),color=HH, width=1.2)+
    ylim(0, 0.7)+
    theme_classic()+
    ylab('P(Risky)')
}