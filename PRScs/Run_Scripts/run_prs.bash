cd /mnt/c/users/Nicolas/Desktop/prs/sum

#DIR="/mnt/c/users/Nicolas/Desktop/prs/sum/"
PRS="/mnt/c/users/Nicolas/Desktop/prs/PRScs/PRScs.py"
REF="/mnt/c/Users/Nicolas/Desktop/prs/PRSref/ldblk_1kg_eur"
#BIM="/mnt/c/Users/Nicolas/Desktop/prs/amostra_alvo/crianças/BANCO_FILTER_ADHD_QC"
BIM="/mnt/c/Users/Nicolas/Desktop/prs/amostra_alvo/adultos/PSY_GSA1-GSA2_merged_geno0.05_maf0.01_mind0.05_hwe1e-6-FINAL-hg19rsID-bravo-dbSNP155-rm-dup-b"
#OUTDIR="/mnt/c/users/Nicolas/Desktop/prs/results/crianças/scores"
OUTDIR="/mnt/c/users/Nicolas/Desktop/prs/results/adultos/scores"

traits=(
IM
CAD
FA
Hip
IC
Stroke
)

files=(
IM_PRS_SE.txt
CAD_PRS_SE.txt
FA_PRS_SE.txt
Hip_PRS_SE.txt
IC_PRS_SE.txt
Stroke_PRS_SE.txt
)

n=(
639221
1165690
1030836
458554
1847875
1308460
)

for i in "${!traits[@]}"
do
    mkdir -p $OUTDIR/${traits[$i]}

    echo "******************************************Calculando PRS para ${traits[$i]} **************************************************************"

    python "$PRS" \
    --ref_dir "$REF" \
    --bim_prefix "$BIM" \
    --sst_file "${files[$i]}" \
    --n_gwas "${n[$i]}" \
    --phi=1e-2 \
    --out_dir "$OUTDIR/${traits[$i]}/${traits[$i]}"

done
