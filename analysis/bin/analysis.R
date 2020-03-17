source("analysis/bin/packages.R")
source("analysis/bin/functions.R")
source("analysis/bin/data.R")

# pacman::p_load(DataExplorer)
# DataExplorer::create_report(DT_final)
head(DT_final)

pacman::p_load(hardhat)
fmla <- as.formula(paste("NodalStage ~ Smoking + Drinking + TstageGroup + ", paste(texture_names, collapse = "+") ))
framed <- model_frame(fmla, DT_final)
hardhat <- model_matrix(framed$terms,framed$data)
hardhat %>% str

Y <- as.numeric(framed$data$NodalStage) - 1


library(glmnet)
XX <- glmnet::makeX(train = DT_final[,-c("NodalStage","HPV","PNI","LVI"),with=F], na.impute = TRUE)
fit <- cv.glmnet(x = XX,y = Y, family = "binomial")
plot(fit)
coef(fit)
glmnet::confusion.glmnet(fit, newx = XX, newy = Y)






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
