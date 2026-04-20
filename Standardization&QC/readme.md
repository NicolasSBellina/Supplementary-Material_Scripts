### Standardization.R

Standardizes GWAS summary statistics from different sources into a unified format for downstream LDSC, PRS-CS, and colocalization analyses.  
The script installs and loads the required packages, reads the original summary statistics file, and allows manual adjustment of separators and input formats depending on the dataset structure.

It supports PGC summary statistics by converting allele frequencies from case/control frequencies into effect allele frequency (EAF).  
The script then renames columns to a standardized structure (CHR, BP, SNP, A1, A2, EAF, MAF, INFO, BETA, SE, OR, P, N, N_CAS, and N_CON), converts genomic positions to rsID when necessary, standardizes allele notation, and optionally swaps alleles if the effect allele is assigned to A2.

Additional transformations include converting EAF to MAF, transforming Odds Ratio (OR) into BETA using `log(OR)`, and manually defining missing sample size information such as total sample size, number of cases, and number of controls.

Finally, the script selects the appropriate columns depending on whether the phenotype is binary (case-control) or quantitative and exports the standardized summary statistics file as a `.tsv` file for the next steps.

### QC.R

Performs general quality control (QC) on GWAS summary statistics before downstream LDSC and PRS-CS analyses.  
The script removes variants without valid rsID, duplicated SNPs, rare variants (`MAF < 0.01`), poorly imputed variants (`INFO <= 0.80`), InDels, CNVs, and ambiguous SNPs (A/T and G/C alleles).

After filtering, it generates formatted output files for both PRS-CS and LDSC analyses.  
For PRS-CS, the script exports files containing SNP ID, alleles, effect size (`BETA`), and either standard error (`SE`) or p-value (`P`).  
For LDSC, it exports summary statistics including chromosome, base pair position, SNP ID, alleles, minor allele frequency, effect size, standard error, p-value, and sample size information.
