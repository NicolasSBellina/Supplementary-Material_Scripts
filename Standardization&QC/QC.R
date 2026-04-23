#----------------------------------------------------------------PACKAGES----------------------------------------------------------------------------------

library(dplyr)

#----------------------------------------------------------------START----------------------------------------------------------------------------------

# insert "directory/file.type" between the double quotes
dir_entrada <- "" 

# read the summary file
sumstats <- read.table(dir_entrada, header=TRUE, sep="\t", stringsAsFactors = FALSE)

#----------------------------------------------------------------General QC----------------------------------------------------------------------------------

sumstats <- sumstats[grepl("^rs", sumstats$SNP), ] # Remove variants without informed rsID

sumstats <- sumstats[!is.na(sumstats$SNP),] # Remove SNPs with missing ID value (NA)

df_processing <- sumstats[!duplicated(sumstats$SNP), ] # Exclude duplicated SNPs (multiallelic)

df_processing <- df_processing[df_processing$MAF >= 0.01,] # Exclude rare variants

df_processing <- df_processing[df_processing$INFO > 0.80,] # If available, exclude variants with low imputation quality

# Exclude InDels and CNVs 
df_processing <- df_processing[df_processing$A1 %in% c("A", "C", "G", "T") & df_processing$A2 %in% c("A", "C", "G", "T"),] 

# Exclude ambiguous SNPs
df_processed <- df_processing[!((df_processing$A1=="A" & df_processing$A2=="T") | (df_processing$A1=="T" & df_processing$A2=="A") | (df_processing$A1=="G" & df_processing$A2=="C") | (df_processing$A1=="C" & df_processing$A2=="G")), ]

#---------------------------------------------------------------- PRS-cs Output ----------------------------------------------------------------------------------

sum_prs <- select(df_processed,SNP,A1,A2,BETA,SE) # PRS using BETA + SE

sum_prs2 <- select(df_processed,SNP,A1,A2,BETA,P) # PRS using BETA + P

#----------------------------------------------------------------LDSC Output----------------------------------------------------------------------------------

# if available, also include the INFO column
sum_ldsc <- select(df_processed,CHR,BP,SNP,A1,A2,MAF,BETA,SE,P,N) # Quantitative

sum_ldsc <- select(df_processed,CHR,BP,SNP,A1,A2,MAF,BETA,SE,P,N_CAS,N_CON) # Qualitative

#----------------------------------------------------------------END----------------------------------------------------------------------------------
dir <- "" # Output file directory

out <- "" # Output file name (preferably use the phenotype abbreviation or name)

# Write files ready for PRS-cs
write.table(sum_prs, paste0(dir, out, "_PRS_SE.txt"), sep="\t", quote=FALSE, row.names=FALSE)

#write.table(sum_prs2, paste0(dir, out, "_PRS_P.txt"), sep="\t", quote=FALSE, row.names=FALSE)

# Write file ready for LDSC
write.table(sum_ldsc, paste0(dir, out, "_LDSC.txt"), sep="\t", quote=FALSE, row.names=FALSE)