# pacman::p_load(DataExplorer)
# DataExplorer::create_report(DT_final)


## ---- load-data ----
source(here::here("analysis/bin/packages.R"))
source(here::here("analysis/bin/functions.R"))
source(here::here("analysis/bin/data.R"))

DT_final$Site %>% table
DT_final[Site=="OSCC"]$HPV %>% table(useNA = "al")
DT_final[, table(Site, HPV, useNA = "al")]
## ---- make-design ----
# fmla <- as.formula(paste("NodalStage ~ Smoking + Drinking + TstageGroup + ",
#                          paste(texture_names, collapse = "+") ))
# framed <- model_frame(fmla, DT_final)
# hardhat <- model_matrix(framed$terms,framed$data)
# Y <- as.numeric(framed$data$NodalStage) - 1
# XX <- glmnet::makeX(train = DT_final[,texture_names,with=F], na.impute = FALSE)

set.seed(1234)
mm <- mice::mice(DT_final, m = 1)
mDT_final <- mice::complete(mm, action = 1)

X_singletask <- mDT_final %>%
  dplyr::select(all_of(c(covariates,texture_names)))

X_singletask <- model.matrix(~., X_singletask)[,-1]

Y_singletask <- mDT_final %>%
    dplyr::select(NodalStage) %>%
    pull() %>%
    as.numeric() %>%
  -1



## ---- fit-lasso ----
cvfit <- cv.glmnet(x = X_singletask,y = Y_singletask, family = "binomial")
coef_1se <- data.frame(feature = names(coef(cvfit, s = "lambda.1se")[-1,]),
                       `coefficient estimate` =  coef(cvfit, s = "lambda.1se")[-1,])
coef_min <- data.frame(feature = names(coef(cvfit, s = "lambda.min")[-1,]),
                       `coefficient estimate` =  coef(cvfit, s = "lambda.min")[-1,])


# ggplot() +
#   geom_point(data = coef_1se, mapping = aes(x = feature, y = `coefficient.estimate`)) +
#   theme(axis.text.x = element_text(angle = 90)) +
#   labs(title = "Lasso solution based on 10-Fold CV and lambda.1se",
#        subtitle = "Nodal Stage prediction using logistic regression with Site, Drinking,Smoking, and texture features")

ggplot() +
  geom_point(data = coef_min, mapping = aes(x = feature, y = `coefficient.estimate`)) +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Lasso solution based on 10-Fold CV and lambda.min",
       subtitle = "Nodal Stage prediction using logistic regression with Site, Drinking,Smoking, and texture features")


## ---- prediction-performance ----

# glmnet::confusion.glmnet(cvfit, newx = X_singletask, newy = Y_singletask)
# tt <- glmnet::roc.glmnet(cvfit, newx = X_singletask, newy = Y_singletask)
# plot(tt[,1],tt[,2], type = "l",
#      main = sprintf("AUC of %.3f",
#                     glmnet::assess.glmnet(cvfit, newx = X_singletask, newy = Y_singletask)$auc),
#      xlab = "False Positive Rate",
#      ylab = "True Positive Rate")
# abline(a=0, b=1)


pred_results <- data.frame(truth = Y_singletask,
                           predicted = predict(cvfit, newx = X_singletask, s = "lambda.min", type = "response"))
# boxplot(X1 ~ truth, data = pred_results)

rocobj <- plot.roc(pred_results$truth, pred_results$X1,
                   main="Lasso with Site, Smoking, Drinking and Texture Features",
                   percent=TRUE,
                   ci=TRUE, # compute AUC (of AUC by default)
                   print.auc=TRUE) # print the AUC (will contain the CI)

ciobj <- ci.se(rocobj, # CI of sensitivity
               specificities=seq(0, 100, 5)) # over a select set of specificities
plot(ciobj, type="shape", col="#1c61b6AA") # plot as a blue shape
plot(ci(rocobj, of="thresholds", thresholds="best")) # add one threshold

## ---- multi-task ----

# set.seed(1234)
# mm <- mice::mice(DT_final, m = 1)
# mDT_final <- mice::complete(mm, action = 1)

# mDT_final %>% dim
# table(DT_final$NodalStage, DT_final$Site, useNA = "al")
# table(DT_final$Site, useNA = "al")
X_multitask <- lapply(unique(mDT_final$Site), function(i) {
  tt <- mDT_final %>%
    filter(Site == i) %>%
    dplyr::select(all_of(c(covariates,texture_names))) %>%
    dplyr::select(-Site)
  model.matrix(~., tt)[,-1]
})
# unique(mDT_final$Site)

names(X_multitask) <- unique(mDT_final$Site)

# lapply(X_multitask, dim)
# table(mDT_final$Site, useNA = "al")

Y_multitask <- lapply(unique(mDT_final$Site), function(i) {
  tm <- mDT_final %>%
    filter(Site == i) %>%
    dplyr::select(NodalStage) %>%
    pull() %>%
    as.numeric()
  matrix(ifelse(tm==1, -1, 1))
})

# lapply(Y_multitask, dim)


Reg = "Lasso"
lambda2 = 0
cvfitr <- cvMTL(X_multitask, Y_multitask, type = "Classification",
                Lam1_seq = 10^seq(2, -4, -.05),
                Lam2 = lambda2,
                Regularization = Reg,
                nfolds = 5, stratify = TRUE, parallel = TRUE, ncores = 8)
# plot(cvfitr)
#
# m <- MTL(X_multitask, Y_multitask, type = "Classification", Regularization = Reg,
#          Lam1=cvfitr$Lam1.min, Lam1_seq=cvfitr$Lam1_seq, Lam2 = lambda2)
# image(t(m$W), xlab="Task Space", ylab="Predictor Space")
# title("The Learnt Model")

m <- MTL(X_multitask, Y_multitask, type = "Classification", Regularization = Reg,
         Lam1=cvfitr$Lam1.min, Lam1_seq=cvfitr$Lam1_seq, Lam2 = lambda2)

coef_multitask <- m$W %>%
  as.data.frame() %>%
  mutate(feature = colnames(X_multitask[[1]])) %>%
  rename(LHC = V1, OSCC = V2, OPC = V3)  %>%
  tidyr::pivot_longer(cols = -feature) %>%
  mutate(feature = factor(feature),
         Site = factor(name))

ggplot() +
  geom_point(data = coef_multitask,
             mapping = aes(x = feature, y = value)) +
  theme(axis.text.x = element_text(angle = 90)) +
  facet_wrap(~Site,ncol = 1) +
  labs(title = "Multi-task Lasso Based on Site",
       subtitle = "Nodal Stage prediction with covariates and texture features",
       caption = "5-Fold CV and lambda.min")


# m<-MTL(X, Y, type="Regression", Regularization="Trace",
#        Lam1=cvfitr$Lam1.min, Lam1_seq=cvfitr$Lam1_seq)




pred_results <- data.frame(truth = factor(do.call(rbind,Y_multitask)),
                           predicted = do.call(rbind, predict(m, X_multitask)))

# boxplot(predicted ~ truth, data = pred_results)

rocobj <- plot.roc(pred_results$truth, pred_results$predicted,
                   main="Multitask Lasso by Site", percent=TRUE,
                   ci=TRUE, # compute AUC (of AUC by default)
                   print.auc=TRUE) # print the AUC (will contain the CI)

ciobj <- ci.se(rocobj, # CI of sensitivity
               specificities=seq(0, 100, 5)) # over a select set of specificities
plot(ciobj, type="shape", col="#1c61b6AA") # plot as a blue shape
plot(ci(rocobj, of="thresholds", thresholds="best")) # add one threshold


## ---- not-used ----

aSAH %>% head

# outcomes
# HPV, LVI, PNI
DT$HPV %>% table(useNA = "al")
DT$LVI %>% table(useNA = "al")
DT$PNI %>% table(useNA = "al")

table(DT$`pN+`, useNA = "al")
DT$N %>% table(useNA = "al")




lapply(X, dim)
lapply(Y, dim)



cvfitr <- cvMTL(X, Y, type = "Regression", Regularization = "Trace", nfolds = 5)
plot(cvfitr)
m<-MTL(X, Y, type="Regression", Regularization="L21",
       Lam1=cvfitr$Lam1.min, Lam1_seq=cvfitr$Lam1_seq)

m<-MTL(X, Y, type="Regression", Regularization="Trace",
       Lam1=cvfitr$Lam1.min, Lam1_seq=cvfitr$Lam1_seq)

image(t(m$W), xlab="Task Space", ylab="Predictor Space")
title("The Learnt Model")

cvMTL()

dev.off()
pacman::p_load(pheatmap)
pheatmap::pheatmap(m$W, cluster_rows = F, cluster_cols = F,
                   labels_row = texture_names, labels_col = unique(DT$Site))

# RTML --------------------------------------------------------------------


datar <- RMTL::Create_simulated_data(Regularization="L21", type="Regression")
datar$X %>% str
datar$Y

cvfitr <- cvMTL(datar$X, datar$Y, type="Regression", Regularization="L21",
                Lam1_seq=10^seq(1,-4, -1),  Lam2=0, opts=list(init=0,  tol=10^-6, maxIter=1500),
                nfolds=5, stratify=FALSE, parallel=FALSE)
cvfitr
plot(cvfitr)


# train
m<-MTL(datar$X, datar$Y, type="Regression", Regularization="L21",
       Lam1=cvfitr$Lam1.min, Lam1_seq=cvfitr$Lam1_seq)
plot(m)

m$W

par(mfrow=c(1,2))
image(t(m$W), xlab="Task Space", ylab="Predictor Space")
title("The Learnt Model")
image(t(datar$W), xlab="Task Space", ylab="Predictor Space")
title("The Ground Truth")





datac <- Create_simulated_data(Regularization="L21", type="Classification", n=100)
# CV without parallel computing
start_time <- Sys.time()

datac$X
cvfitc<-cvMTL(datac$X, datac$Y, type="Classification", Regularization="L21", stratify=TRUE, parallel=FALSE)
Sys.time()-start_time
#> Time difference of 0.44733 secs

# CV with parallel computing
start_time <- Sys.time()
cvfitc<-cvMTL(datac$X, datac$Y, type="Classification", Regularization="L21", stratify=TRUE, parallel=TRUE, ncores=2)
datac$X[[1]][2:7,5]<-NA

Sys.time()-start_time



