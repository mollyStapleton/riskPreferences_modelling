}
# i = 0;
# iters=100000;
# up_thr=100;
# low_thr = 1;
# mu_mat=c(40,40,60,60);
# sd_mat=c(5,15,5,15);
# 
# mu = 0;
# R  = 0;
# Q = 0;

# for (i in 1:4){
#   
#   mu=mu_mat[(i)];
#   sd=sd_mat[(i)]; 
#   R = rnorm(iters, mu, sd);
#   remIdx <-(R <=mu | R <= up_thr);
#   R[!R == remIdx];
#   remIdx <- (R <=mu | R <= low_thr);
#   R[!R == remIdx];
#   Q$new <- (mu-(R-mu));
#   R <- c(R, Q$new);
#   
# }
# 
#   mu=mu_mat(i);sd=sd_mat(i); 
#   R = ((1,iters)*sd+mu);
#   
#   R((R<=mu | R>=up_thr))= c(); 
#   R((R<=mu | R <= low_thr)) = c();
#   Q=mu-(R-mu); 
#   R=c(Q R); 
#   folded(i,:)=c(mean(R) std(R));
#   rewardDists{i} = R;
# 
# }
