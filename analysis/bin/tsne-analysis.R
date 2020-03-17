DT1 <- read.csv("~/Dropbox/mcgill/radiology/reza/hnscct/HNSCCT-input.csv")
DT2 <- read.csv("~/Dropbox/mcgill/radiology/reza/hnscct/HNSCCT-outcome.csv")
colnames(DT1)
DT1.features <- as.matrix(DT1[, -c(1,2)])


pacman::p_load(Rtsne)
pacman::p_load(magrittr)
set.seed(42) # Sets seed for reproducibility
tsne_out <- Rtsne(DT1.features, dims = 3) # Run TSNE
plot(tsne_out$Y,col=as.numeric(DT2$Ds.Site),asp=1, pch = 19, cex=1.5) # Plot the result
tsne_out$Y
prcomp()

image(tsne_out$Y)

DT2$Ds.Site %>% table
DT2$Ds.Site %>% as.numeric

pacman::p_load(rgl)
open3d()
x <- sort(rnorm(1000))
y <- rnorm(1000)
z <- rnorm(1000) + atan2(x, y)
plot3d(x, y, z, col = rainbow(1000))
plot3d(tsne_out$Y, col = as.numeric(DT2$Ds.Site))



pacman::p_load(factoextra)
res.pca <- prcomp(DT1.features, scale = TRUE)
fviz_eig(res.pca)
fviz_pca_ind(res.pca,
             col.ind = "cos2", # Color by the quality of representation
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)


fviz_pca_var(res.pca,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)





# 1. Individual coordinates
res.ind <- get_pca_ind(res.pca)

plot3d(res.ind$coord[,1:3], col = as.numeric(DT2$Ds.Site))
plot(res.ind$coord[,1:2],col=as.numeric(DT2$Ds.Site),asp=1, pch = 19, cex=1.5) # Plot the result



distance <- get_dist(DT1.features, "spearman")
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))
k2 <- kmeans(DT1.features, centers = 9, nstart = 50)
fviz_cluster(k2, data = DT1.features)

table(k2$cluster, DT2$T)

fviz_nbclust(DT1.features, kmeans, method = "wss")

