library(rstan)
library(varhandle)

source(here::here("analysis/bin/packages.R"))
source(here::here("analysis/bin/functions.R"))
source(here::here("analysis/bin/data.R"))

missing = which(!complete.cases(DT_final[,5:8]))
DT_final0 = DT_final[-missing,]
df_feature = DT_final0[,9:ncol(DT_final0)]
std = function(x) return((x - mean(x))/sd(x))
df_std = data.frame(apply(df_feature, 2, std))
y = as.numeric(DT_final0$HPV)
y[y==1] = 0
y[y==2] = 1
y_obs = y[!is.na(y)]
nas = which(is.na(y))
N_mis = length(nas)

dummy_fun = function(x) to.dummy(x, prefix = names(x))[,1:(length(table(x))-1)]
Z = cbind(dummy_fun(DT_final0[,6]), dummy_fun(DT_final0[,7]), dummy_fun(DT_final0[,8]))
S = as.numeric(DT_final0$Site)
Z_mis = Z[nas,]
Z_obs = Z[-nas,]
X = df_std
X_obs = X[-nas,]
X_mis = X[nas,]
S_obs = S[-nas]
S_mis = S[nas]
y2 = as.numeric(DT_final0$NodalStage)
y2[y2==1] = 0
y2[y2==2] = 1
y_obs2 = y2[-nas]
y_mis2 = y2[nas]

data = list(N = length(y_obs) + N_mis, N_obs = length(y_obs), N_mis = N_mis, M = ncol(df_std), L = ncol(Z_obs), R = 3, S_obs = S_obs,
            S_mis = S_mis, y_obs = y_obs, y_obs2 = y_obs2, y_mis2 = y_mis2, X_obs = X_obs, X_mis = X_mis, Z_mis = Z_mis, Z_obs = Z_obs)
fit <- stan(file=here::here("src/stan_files/model/mv_LLFH_bysite_wMissing_2.stan"),
                    data=data, seed=4938483, chains = 2,
                    control=list(adapt_delta=0.99, max_treedepth=15))
fit_res = extract(fit)
save(fit_res, file = 'NS_HPV_bySite_all.Rdata')
beta1 = fit_res$beta
#save(beta1, file = 'Finnish_horseshoe.Rdata')
bq25 = apply(beta1, c(2,3), quantile, p = c(.025))
bq5 = apply(beta1, c(2,3), quantile, p = c(.5))
bq75 = apply(beta1, c(2,3), quantile, p = c(.975))
bq = data.frame(lower = c(bq25), est = c(bq5), upper = c(bq75), Site = rep(c(1,2,3), each = 36))
#save(bq, file = 'slope_bySite.Rdata')
ggplot(bq, aes(x = rep(names(df_feature), 3), y = est)) + geom_point() +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.1) +
  facet_grid(Site ~ .) +
  xlab('feature') + ylab('coefficient estimate') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

beta2 = fit_res$beta2
#save(beta1, file = 'Finnish_horseshoe.Rdata')
bq25 = apply(beta2, c(2,3), quantile, p = c(.025))
bq5 = apply(beta2, c(2,3), quantile, p = c(.5))
bq75 = apply(beta2, c(2,3), quantile, p = c(.975))
bq2 = data.frame(lower = c(bq25), est = c(bq5), upper = c(bq75), Site = rep(c(1,2,3), each = 36))
#save(bq, file = 'slope_bySite.Rdata')
ggplot(bq2, aes(x = rep(names(df_feature), 3), y = est)) + geom_point() +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.1) +
  facet_grid(Site ~ .) +
  xlab('feature') + ylab('coefficient estimate') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


#### prediction accuracy #####
yh_obs = fit_res$yhat_obs2
yh_mis = fit_res$yhat_mis2
yhat = matrix(NA, nrow = 2000, ncol = nrow(DT_final0))
yhat[,-nas] = yh_obs
yhat[,nas] = yh_mis
y = y2

t = seq(0,1,.01)
index = sample(1:2000, 100, replace = F)
roc1 = data.frame(ind = rep(1, length(t)), t = t, TPR = sapply(t, sensfun, yhat[1,], y), FPR = sapply(t, specfun, yhat[1,], y))
AUC = NULL
AUC = auc(roc1$TPR, 1-roc1$FPR)
j = 1
plot(roc1$FPR, roc1$TPR, col = 'grey', type = 'l', ylab = 'TPR', xlab = 'FPR')
for (i in index) {
  j = j + 1
  roc11 = data.frame(ind = rep(j, length(t)), t = t, TPR = sapply(t, sensfun, yhat[i,], y), FPR = sapply(t, specfun, yhat[i,], y))
  rbind(roc1, roc11)
  lines(roc11$FPR, roc11$TPR, col = 'grey')
  AUC = c(AUC, auc(roc11$TPR, 1-roc11$FPR))
}
abline(0,1)
title(main = paste(round(min(AUC),2), '<AUC<', round(max(AUC),2)))

yhat_mean = apply(yhat, 2, mean)
MSE = mean((yhat_mean - yhat)^2)


################################################################

yh_obs = fit_res$yhat_obs
y = as.numeric(DT_final0$HPV)
y[y==1] = 0
y[y==2] = 1
y_obs = y[!is.na(y)]

t = seq(0,1,.01)
index = sample(1:2000, 100, replace = F)
roc1 = data.frame(ind = rep(1, length(t)), t = t, TPR = sapply(t, sensfun, yh_obs[1,], y_obs), FPR = sapply(t, specfun, yh_obs[1,], y_obs))
AUC = NULL
AUC = auc(roc1$TPR, 1-roc1$FPR)
j = 1
plot(roc1$FPR, roc1$TPR, col = 'grey', type = 'l', ylab = 'TPR', xlab = 'FPR')
for (i in index) {
  j = j + 1
  roc11 = data.frame(ind = rep(j, length(t)), t = t, TPR = sapply(t, sensfun, yh_obs[i,], y_obs), FPR = sapply(t, specfun, yh_obs[i,], y_obs))
  rbind(roc1, roc11)
  lines(roc11$FPR, roc11$TPR, col = 'grey')
  AUC = c(AUC, auc(roc11$TPR, 1-roc11$FPR))
}
abline(0,1)
title(main = paste(round(min(AUC),2), '<AUC<', round(max(AUC),2)))


