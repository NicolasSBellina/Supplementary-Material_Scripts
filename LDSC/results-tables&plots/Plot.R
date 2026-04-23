library(tidyr)
library(dplyr)
library(corrplot)

# read table
df <- read.table("C:/Users/Nicolas/Desktop/sum_hm3_ldsc/results/qualitativo/rg_long.tsv", header=TRUE, sep="\t")

df$p1 <- ifelse(df$p1 == "IM","MI",df$p1)
df$p2 <- ifelse(df$p2 == "IM","MI",df$p2)

df$p1 <- ifelse(df$p1 == "Hip","Hypertension",df$p1)
df$p2 <- ifelse(df$p2 == "Hip","Hypertension",df$p2)

df$p1 <- ifelse(df$p1 == "FA","AF",df$p1)
df$p2 <- ifelse(df$p2 == "FA","AF",df$p2)

df$p1 <- ifelse(df$p1 == "FC","HR",df$p1)
df$p2 <- ifelse(df$p2 == "FC","HR",df$p2)

df$p1 <- ifelse(df$p1 == "IC","HF",df$p1)
df$p2 <- ifelse(df$p2 == "IC","HF",df$p2)

tdah <- "ADHD"

# >>> EDIT HERE according to your phenotypes
qualitativos <- c("CAD", "MI", "HF", "AF", "Stroke", "DCM", "Hypertension")
quantitativos <- c("SBP", "DBP", "PP", "HR")

rg_qual <- df %>%
  filter((p1 == tdah & p2 %in% qualitativos) |
           (p2 == tdah & p1 %in% qualitativos)) %>%
  mutate(trait = ifelse(p1 == tdah, p2, p1)) %>%
  arrange(desc(rg))

ord_qual <- rg_qual$trait

rg_quant <- df %>%
  filter((p1 == tdah & p2 %in% quantitativos) |
           (p2 == tdah & p1 %in% quantitativos)) %>%
  mutate(trait = ifelse(p1 == tdah, p2, p1)) %>%
  arrange(desc(rg))

ord_quant <- rg_quant$trait

traits <- c(tdah, ord_qual, ord_quant)

# force order as factor (important)
df$p1 <- factor(df$p1, levels = traits)
df$p2 <- factor(df$p2, levels = traits)

# rg matrix
mat <- matrix(NA, length(traits), length(traits))
rownames(mat) <- traits
colnames(mat) <- traits

# p-value matrix
p_mat <- matrix(NA, length(traits), length(traits))
rownames(p_mat) <- traits
colnames(p_mat) <- traits

# fill matrices
for(i in 1:nrow(df)){
  
  t1 <- df$p1[i]
  t2 <- df$p2[i]
  
  r <- as.numeric(df$rg[i])
  p <- as.numeric(df$p[i])
  
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

legend("right",
       legend=c("* p < 0.00454"),
       bty="n",
       xpd = TRUE,         # allows drawing outside the plot
       cex = 1.1)

# Plot package link: https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html