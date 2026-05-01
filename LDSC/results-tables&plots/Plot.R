library(tidyr)
library(dplyr)
library(corrplot)

setwd("C:/Users/Nicolas/Desktop/sum_hm3_ldsc/results/qualitativo/")

png("temp2.png", width=10*400, height=5*400, res=400)
par(mfrow=c(1,2), mar=c(4, 4, 2, 2))

# read table
ADHD_Diag <- read.table("C:/Users/Nicolas/Desktop/sum_hm3_ldsc/results/qualitativo/rg_long.tsv", header=TRUE, sep="\t")
ADHD_Symp <-  read.table("C:/Users/Nicolas/Desktop/sum_hm3_ldsc/results/quantitativo/rg_long.tsv", header=TRUE, sep="\t")

ADHD_Diag$p1 <- ifelse(ADHD_Diag$p1 == "IM","MI",ADHD_Diag$p1)
ADHD_Diag$p2 <- ifelse(ADHD_Diag$p2 == "IM","MI",ADHD_Diag$p2)

ADHD_Diag$p1 <- ifelse(ADHD_Diag$p1 == "Hip","Hypertension",ADHD_Diag$p1)
ADHD_Diag$p2 <- ifelse(ADHD_Diag$p2 == "Hip","Hypertension",ADHD_Diag$p2)

ADHD_Diag$p1 <- ifelse(ADHD_Diag$p1 == "FA","AF",ADHD_Diag$p1)
ADHD_Diag$p2 <- ifelse(ADHD_Diag$p2 == "FA","AF",ADHD_Diag$p2)

ADHD_Diag$p1 <- ifelse(ADHD_Diag$p1 == "FC","HR",ADHD_Diag$p1)
ADHD_Diag$p2 <- ifelse(ADHD_Diag$p2 == "FC","HR",ADHD_Diag$p2)

ADHD_Diag$p1 <- ifelse(ADHD_Diag$p1 == "IC","HF",ADHD_Diag$p1)
ADHD_Diag$p2 <- ifelse(ADHD_Diag$p2 == "IC","HF",ADHD_Diag$p2)

tdah <- "ADHD_Diag"

# >>> EDIT HERE according to your phenotypes
qualitativos <- c("HF", "Stroke", "MI", "CAD", "Hypertension", "AF", "DCM")
quantitativos <- c("SBP", "DBP", "PP", "HR")


traits <- c(tdah, qualitativos, quantitativos)

# force order as factor (important)
ADHD_Diag$p1 <- factor(ADHD_Diag$p1, levels = traits)
ADHD_Diag$p2 <- factor(ADHD_Diag$p2, levels = traits)

# rg mat_Diagrix
mat_Diag <- matrix(NA, length(traits), length(traits))
rownames(mat_Diag) <- traits
colnames(mat_Diag) <- traits

# p-value mat_Diagrix
p_mat_Diag <- matrix(NA, length(traits), length(traits))
rownames(p_mat_Diag) <- traits
colnames(p_mat_Diag) <- traits

# fill mat_Diagrices
for(i in 1:nrow(ADHD_Diag)){
  
  t1 <- ADHD_Diag$p1[i]
  t2 <- ADHD_Diag$p2[i]
  
  r <- as.numeric(ADHD_Diag$rg[i])
  p <- as.numeric(ADHD_Diag$p[i])
  
  mat_Diag[t1,t2] <- r
  mat_Diag[t2,t1] <- r
  
  p_mat_Diag[t1,t2] <- p
  p_mat_Diag[t2,t1] <- p
}

# diagonal
diag(mat_Diag) <- 1
diag(p_mat_Diag) <- 0

# replace NA
mat_Diag[is.na(mat_Diag)] <- 0
p_mat_Diag[is.na(p_mat_Diag)] <- 1

# plot
corrplot(mat_Diag,
         method="color",
         type="full",
         tl.col="black",
         tl.srt=45,
         col=colorRampPalette(c("blue","white","red"))(200),
         p.mat=p_mat_Diag,
         sig.level=0.00454,
         insig="label_sig",
         pch.cex=1.3,
         pch.col="black")

legend("bottom",
       legend=c("A"),
       bty="n",
       xpd = TRUE,
       cex = 1.1)

tdah <- "ADHD_Symp"

traits <- c(tdah, qualitativos, quantitativos)

ADHD_Symp$p1 <- ifelse(ADHD_Symp$p1 == "IM","MI",ADHD_Symp$p1)
ADHD_Symp$p2 <- ifelse(ADHD_Symp$p2 == "IM","MI",ADHD_Symp$p2)

ADHD_Symp$p1 <- ifelse(ADHD_Symp$p1 == "Hip","Hypertension",ADHD_Symp$p1)
ADHD_Symp$p2 <- ifelse(ADHD_Symp$p2 == "Hip","Hypertension",ADHD_Symp$p2)

ADHD_Symp$p1 <- ifelse(ADHD_Symp$p1 == "FA","AF",ADHD_Symp$p1)
ADHD_Symp$p2 <- ifelse(ADHD_Symp$p2 == "FA","AF",ADHD_Symp$p2)

ADHD_Symp$p1 <- ifelse(ADHD_Symp$p1 == "FC","HR",ADHD_Symp$p1)
ADHD_Symp$p2 <- ifelse(ADHD_Symp$p2 == "FC","HR",ADHD_Symp$p2)

ADHD_Symp$p1 <- ifelse(ADHD_Symp$p1 == "IC","HF",ADHD_Symp$p1)
ADHD_Symp$p2 <- ifelse(ADHD_Symp$p2 == "IC","HF",ADHD_Symp$p2)

# force order as factor (important)
ADHD_Symp$p1 <- factor(ADHD_Symp$p1, levels = traits)
ADHD_Symp$p2 <- factor(ADHD_Symp$p2, levels = traits)

# rg matrix
mat <- matrix(NA, length(traits), length(traits))
rownames(mat) <- traits
colnames(mat) <- traits

# p-value matrix
p_mat <- matrix(NA, length(traits), length(traits))
rownames(p_mat) <- traits
colnames(p_mat) <- traits

# fill matrices
for(i in 1:nrow(ADHD_Symp)){
  
  t1 <- ADHD_Symp$p1[i]
  t2 <- ADHD_Symp$p2[i]
  
  r <- as.numeric(ADHD_Symp$rg[i])
  p <- as.numeric(ADHD_Symp$p[i])
  
  mat[t1,t2] <- r
  mat[t2,t1] <- r
  
  p_mat[t1,t2] <- p
  p_mat[t2,t1] <- p
}

# diagonal
diag(mat) <- 1
diag(p_mat) <- 0

# replace NA
mat[is.na(mat)] <- 0
p_mat[is.na(p_mat)] <- 1

# plot
corrplot(mat,
         method="color",
         type="full",
         tl.col="black",
         tl.srt=45,
         col=colorRampPalette(c("blue","white","red"))(200),
         p.mat=p_mat,
         sig.level=0.00454,
         insig="label_sig",
         pch.cex=1.3,
         pch.col="black")

legend("bottom",
       legend=c("B"),
       bty="n",
       xpd = TRUE,
       cex = 1.1)

dev.off()
# Plot package link: https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html
