Scripts used to run the LDSC analysis:

### run_munge.bash:

Runs `munge_sumstats.py` for all GWAS summary statistics files.  
The script standardizes the summary statistics to run LDSC. Even though the quality filters `INFO` and `N` have already been applied, applies `INFO > 0.8` and minimum sample size (`N > 1000`), matches SNPs to HapMap3 variants using `w_hm3.snplist`, and generates `.sumstats.gz` files formatted for LDSC analysis.

### run_ldsc.bash:

Runs pairwise genetic correlation analysis using LDSC (`ldsc.py`) across multiple phenotypes.  
The script defines phenotype names, summary statistics files, sample prevalence, and population prevalence values, then iteratively runs each phenotype as the primary trait against all others using the `--rg` parameter, generating correlation result files for each phenotype.
