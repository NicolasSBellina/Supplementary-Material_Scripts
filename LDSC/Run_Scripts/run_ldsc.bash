#!/bin/bash

cd /mnt/c/Users/Nicolas/Desktop/sum_hm3_ldsc/ 

# fixed directories
LDSC="/mnt/c/users/Nicolas/desktop/ldsc/ldsc.py"
REF="/mnt/c/users/Nicolas/desktop/ldsc_ref/LDscore/LDscore.@"
WLD="/mnt/c/users/Nicolas/desktop/ldsc_ref/1000G_Phase3_weights_hm3_no_MHC/weights.hm3_noMHC.@"
OUTDIR="/mnt/c/users/Nicolas/desktop/sum_hm3_ldsc/results/qualitativo"

#OUTDIR="/mnt/c/users/Nicolas/desktop/resultadosteste"

# Phenotypes in order
traits=(
ADHD
IM
DCM
CAD
FA
Hip
IC
Stroke
FC
DBP
PP
SBP
)

# sumstats files
files=(
ADHD_hm3_munge.sumstats.gz
IM_hm3_munge.sumstats.gz
DCM_hm3_munge.sumstats.gz
CAD_hm3_munge.sumstats.gz
FA_hm3_munge.sumstats.gz
Hip_hm3_munge.sumstats.gz
IC_hm3_munge.sumstats.gz
Stroke_hm3_munge.sumstats.gz
FC_hm3_munge.sumstats.gz
DBP_hm3_munge.sumstats.gz
PP_hm3_munge.sumstats.gz
SBP_hm3_munge.sumstats.gz
)

# Sample prevalence
samp_prev=(
0.1716
0.0962
0.0050
0.1557
0.0588
0.3158
0.0755
0.0563
nan
nan
nan
nan
)

# Population prevalence
pop_prev=(
0.05
0.038
0.00037
0.036
0.0446
0.44
0.017
0.092
nan
nan
nan
nan
)

# Loop to run each phenotype as the main one.
for i in "${!traits[@]}"
do
    rg_list="${files[$i]}"
    samp_list="${samp_prev[$i]}"
    pop_list="${pop_prev[$i]}"

    for j in "${!traits[@]}"
    do
        if [ $j -ne $i ]; then
            rg_list="${rg_list},${files[$j]}"
            samp_list="${samp_list},${samp_prev[$j]}"
            pop_list="${pop_list},${pop_prev[$j]}"
        fi
    done

    echo "Rodando ${traits[$i]} como fenótipo principal..."

    python "$LDSC" \
    --rg "$rg_list" \
    --ref-ld-chr "$REF" \
    --w-ld-chr "$WLD" \
    --samp-prev "$samp_list" \
    --pop-prev "$pop_list" \
    --out "$OUTDIR/${traits[$i]}_quali"

done
