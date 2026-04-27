#----------------------------------------------------------------PACKAGE INSTALLATION *RUN ONLY ONCE*----------------------------------------------------------------------------------

# It is necessary to link GitHub to download the colochelpR package using valid credentials
install.packages("remotes")
install.packages("BiocManager")
BiocManager::install(c("SNPlocs.Hsapiens.dbSNP155.GRCh37","dplyr"))
remotes::install_github("RHReynolds/colochelpR")

#----------------------------------------------------------------PACKAGES----------------------------------------------------------------------------------

library(dplyr)
library(SNPlocs.Hsapiens.dbSNP155.GRCh37)
library(colochelpR)

#----------------------------------------------------------------START----------------------------------------------------------------------------------

# Insert "directory/file.type" of the summary statistics file inside the double quotes
dir_entrada <- ""

# Read the summary statistics file
sum <- read.table(dir_entrada, header = TRUE, sep = "\t") 
# WARNING: In some cases it is necessary to change 'sep', which is the character responsible for separating the columns

#----------------------------------------------------------------PGC SUMMARY STATISTICS----------------------------------------------------------------------------------

# If the dataset is from PGC, it is necessary to convert allele frequencies from cases and controls into effect allele frequency (EAF)
sum$EAF <- ((sum$FRQ_A_xxxx*sum$Nca) + (sum$FRQ_U_xxxxx*sum$Nco))/(sum$Nca + sum$Nco)

#----------------------------------------------------------------RENAMING COLUMNS----------------------------------------------------------------------------------

# Rename existing columns for standardization (if a column does not exist, remove it from the function)
sum <- sum %>%
  dplyr::rename(CHR = ,         # Chromosome column
                BP = ,          # Variant position in base pairs. Usually named POS or LOC
                SNP = ,         # rsID
                A1 = ,          # Effect allele or reference allele used to calculate BETA
                A2 = ,          # Non-effect allele
                EAF = ,         # Effect Allele Frequency
                MAF = ,         # Minor Allele Frequency               WARNING: May not exist
                INFO = ,        # Imputation quality                   WARNING: May not exist
                BETA = ,        # Variant effect on the phenotype
                SE = ,          # Standard error of the variant effect
                OR = ,          # Another effect measure               WARNING: Use only BETA; if BETA does not exist, convert Odds Ratio to BETA using log(OR)
                P = ,           # Variant significance
                N = ,           # Total study sample size or per-variant sample size     WARNING: May not exist
                N_CAS = ,       # Number of cases in the study or per variant            WARNING: May not exist
                N_CON = ,)      # Number of controls in the study or per variant         WARNING: May not exist

# For quantitative phenotypes, the columns N_CAS and N_CON should not exist

# Convert genomic position to rsID if the SNP (rsID) column does not exist
sum <- convert_loc_to_rs(sum, SNPlocs.Hsapiens.dbSNP155.GRCh37)

#----------------------------------------------------------------ALLELES (A1 and A2)----------------------------------------------------------------------------------

# If BETA was calculated using A2, the columns can be swapped so that A1 becomes the effect allele
aux <- sum$A2
sum$A2 <- sum$A1
sum$A1 <- aux

sum$BETA <- -sum$BETA
# If alleles are written in lowercase letters, convert them to uppercase
sum$A1 <- toupper(sum$A1)
sum$A2 <- toupper(sum$A2)

#----------------------------------------------------------------MAF----------------------------------------------------------------------------------

# Convert EAF to MAF if the MAF column does not exist
sum$MAF <- ifelse(sum$EAF < (1 - sum$EAF), sum$EAF, 1 - sum$EAF)

#----------------------------------------------------------------BETA----------------------------------------------------------------------------------

# Convert Odds Ratio to BETA
sum$BETA <- log(sum$OR)

#----------------------------------------------------------------N----------------------------------------------------------------------------------

# If the summary statistics file does not contain total N
N <- 1308460     
# Insert the total study sample size here
# WARNING: Only use this if the N column does not exist in the summary statistics

sum$N <- N

# If the summary statistics file does not contain the number of cases
Nca <- 73652     
# Insert the number of cases here
# WARNING: Only use this if the N_CAS column does not exist in the summary statistics

sum$N_CAS <- Nca

# If the summary statistics file does not contain the number of controls
Nco <- 0000      
# Insert the number of controls here
# WARNING: Only use this if the N_CON column does not exist in the summary statistics

sum$N_CON <- Nco

# Alternatively:

# If the summary statistics file does not contain the number of controls, but contains N and N cases
sum$N_CON <- (sum$N - sum$N_CAS)   
# Calculates the number of controls for each variant or for the whole study
# WARNING: Only use this if the N_CON column does not exist in the summary statistics

# If the summary statistics file contains cases and controls, but does not contain total N
sum$N <- sum$N_CAS + sum$N_CON
# WARNING: Only use this if the N column does not exist in the summary statistics

#----------------------------------------------------------------END----------------------------------------------------------------------------------

# Select the columns that will be used in the next step

sum <- select(sum, CHR, BP, SNP, A1, A2, MAF, BETA, SE, P, N_CAS, N_CON) # Binary phenotype

sum <- select(sum, CHR, BP, SNP, A1, A2, MAF, BETA, SE, P, N) # Quantitative phenotype

# If INFO exists, include it after MAF as follows:

sum <- select(sum, CHR, BP, SNP, A1, A2, MAF, INFO, BETA, SE, P, N_CAS, N_CON) # Binary phenotype

sum <- select(sum, CHR, BP, SNP, A1, A2, MAF, INFO, BETA, SE, P, N) # Quantitative phenotype

# Insert the output directory path (include a "/" at the end)
dir_saida <- ""

# Write the output file name
out <- ""

# Write the output file
write.table(sum, paste0(dir_saida, out, "_sum.tsv"), sep = "\t", row.names = FALSE, quote = FALSE)
