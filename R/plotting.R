load('NS_HPV_bySite_all.Rdata')
beta1 = fit_res$beta
#save(beta1, file = 'Finnish_horseshoe.Rdata')
bq25 = apply(beta1, c(2,3), quantile, p = c(.025))
bq5 = apply(beta1, c(2,3), quantile, p = c(.5))
bq75 = apply(beta1, c(2,3), quantile, p = c(.975))
bq = data.frame(lower = c(bq25), est = c(bq5), upper = c(bq75), Site = rep(c(1,2,3), each = 36))
#save(bq, file = 'slope_bySite.Rdata')
bq$Site = plyr::mapvalues(bq$Site, c(1,2,3), c('LHC', 'OPC', 'OSCC'))
ggplot(bq, aes(x = rep(names(df_feature), 3), y = est)) + geom_point() + 
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.1) +
  facet_grid(Site ~ .) +
  xlab('feature') + ylab('coefficient estimate') + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggsave('mv_NS_feat.png')

beta2 = fit_res$beta2
#save(beta1, file = 'Finnish_horseshoe.Rdata')
bq25 = apply(beta2, c(2,3), quantile, p = c(.025))
bq5 = apply(beta2, c(2,3), quantile, p = c(.5))
bq75 = apply(beta2, c(2,3), quantile, p = c(.975))
bq = data.frame(lower = c(bq25), est = c(bq5), upper = c(bq75), Site = rep(c(1,2,3), each = 36))
#save(bq, file = 'slope_bySite.Rdata')
bq$Site = plyr::mapvalues(bq$Site, c(1,2,3), c('LHC', 'OPC', 'OSCC'))
ggplot(bq, aes(x = rep(names(df_feature), 3), y = est)) + geom_point() + 
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.1) +
  facet_grid(Site ~ .) +
  xlab('feature') + ylab('coefficient estimate') + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggsave('mv_HPV_feat.png')

load('slope_bySite_all.Rdata')
beta = fin_res$beta
#save(beta1, file = 'Finnish_horseshoe.Rdata')
bq25 = apply(beta, c(2,3), quantile, p = c(.025))
bq5 = apply(beta, c(2,3), quantile, p = c(.5))
bq75 = apply(beta, c(2,3), quantile, p = c(.975))
bq = data.frame(lower = c(bq25), est = c(bq5), upper = c(bq75), Site = rep(c(1,2,3), each = 36))
#save(bq, file = 'slope_bySite.Rdata')
bq$Site = plyr::mapvalues(bq$Site, c(1,2,3), c('LHC', 'OPC', 'OSCC'))
ggplot(bq, aes(x = rep(names(df_feature), 3), y = est)) + geom_point() + 
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.1) +
  facet_grid(Site ~ .) +
  xlab('feature') + ylab('coefficient estimate') + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggsave('NS_feat.png')



########################################################################
### Calibration curves ####
yh_obs = fit_res$yhat_obs2
yh_mis = fit_res$yhat_mis2
yhat = matrix(NA, nrow = 2000, ncol = nrow(DT_final0))
yhat[,-nas] = yh_obs
yhat[,nas] = yh_mis
y = y2

par(mfrow= c(1,2))
yhat0 = apply(yhat, 2, mean)
index = sample(1:2000, 100)
mse0 = NULL
m0 = glm(y ~ yhat[1,], family = binomial)
plot(sort(yhat[1,]), sort(m0$fitted.values), type = 'l', col = 'grey', 
     xlab = 'predicted', ylab = 'observed')
title('model with HPV')
for (i in index){
  m0 = glm(y ~ yhat[i,], family = binomial)
  mse0 = c(mse0, mean((yhat[i,] - m0$fitted.values)^2))
  lines(sort(yhat[1,]), sort(m0$fitted.values), col = 'grey')
}
abline(0,1)

m0 = glm(y ~ yhat0, family = binomial)
mse00 = mean((yhat0 - m0$fitted.values)^2)


yhat1 = fin_res$yhat
yhat10 = apply(yhat1, 2, mean)
mse1 = NULL
m1 = glm(y ~ yhat1[1,], family = binomial)
plot(sort(yhat1[1,]), sort(m1$fitted.values), type = 'l', col = 'grey', 
     xlab = 'predicted', ylab = 'observed')
title('model without HPV')
for (i in index){
  m1 = glm(y ~ yhat1[i,], family = binomial)
  mse1 = c(mse1, mean((yhat1[i,] - m1$fitted.values)^2))
  lines(sort(yhat1[1,]), sort(m1$fitted.values), col = 'grey')
}
abline(0,1)
m1 = glm(y ~ yhat10, family = binomial)
mse10 = mean((yhat10 - m1$fitted.values)^2)
