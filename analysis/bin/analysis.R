# pacman::p_load(DataExplorer)
# DataExplorer::create_report(DT_final)


## ---- load-data ----
source(here::here("analysis/bin/packages.R"))
source(here::here("analysis/bin/functions.R"))
source(here::here("analysis/bin/data.R"))


## ---- make-design ----
fmla <- as.formula(paste("NodalStage ~ Smoking + Drinking + TstageGroup + ", paste(texture_names, collapse = "+") ))
framed <- model_frame(fmla, DT_final)
hardhat <- model_matrix(framed$terms,framed$data)
# hardhat %>% str
# head(hardhat)
Y <- as.numeric(framed$data$NodalStage) - 1
XX <- glmnet::makeX(train = DT_final[,texture_names,with=F], na.impute = FALSE)


## ---- fit-lasso ----
cvfit <- cv.glmnet(x = XX,y = Y, family = "binomial")
# plot(cvfit)
# coef(cvfit)

# pacman::p_load(coefplot)
#
# coef(fit)[glmnet:::nonzeroCoef(coef(fit)),,drop=F]
# coef(fit,s="lambda.min")[glmnet:::nonzeroCoef(coef(fit,s="lambda.min")),,drop=F]

coef_1se <- data.frame(feature = names(coef(cvfit, s = "lambda.1se")[-1,]), `coefficient estimate` =  coef(cvfit, s = "lambda.1se")[-1,])
coef_min <- data.frame(feature = names(coef(cvfit, s = "lambda.min")[-1,]), `coefficient estimate` =  coef(cvfit, s = "lambda.min")[-1,])


ggplot() +
  geom_point(data = coef_1se, mapping = aes(x = feature, y = `coefficient.estimate`)) +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Lasso solution based on 10-Fold CV and lambda.1se",
       subtitle = "Nodal Stage prediction using logistic regression with texture features only")

ggplot() +
  geom_point(data = coef_min, mapping = aes(x = feature, y = `coefficient.estimate`)) +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Lasso solution based on 10-Fold CV and lambda.min",
       subtitle = "Nodal Stage prediction using logistic regression with texture features only")


## ---- prediction-performance ----

glmnet::confusion.glmnet(cvfit, newx = XX, newy = Y)
tt <- glmnet::roc.glmnet(cvfit, newx = XX, newy = Y)
plot(tt[,1],tt[,2], type = "l",
     main = sprintf("AUC of %.3f",glmnet::assess.glmnet(cvfit, newx = XX, newy = Y)$auc),
     xlab = "False Positive Rate",
     ylab = "True Positive Rate")
abline(a=0, b=1)

## ---- not-used ----
X <- lapply(unique(DT$Site), function(i) {
  DT[Site == i, ..texture_names]
})

Y <- lapply(unique(DT$Site), function(i) {
  Y = DT[Site == i, "Age"]
})

DT$Age
DT$Stage %>% table(useNA = "al")
DT$Dx %>%  table(useNA = "al")

DT$T %>% table(useNA = "al")

# outcomes
# HPV, LVI, PNI
DT$HPV %>% table(useNA = "al")
DT$LVI %>% table(useNA = "al")
DT$PNI %>% table(useNA = "al")

table(DT$`pN+`, useNA = "al")
DT$N %>% table(useNA = "al")


cvfitr <- cvMTL(X, Y, type = "Regression", Regularization = "L21", nfolds = 5)
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


datar <- Create_simulated_data(Regularization="L21", type="Regression")
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
