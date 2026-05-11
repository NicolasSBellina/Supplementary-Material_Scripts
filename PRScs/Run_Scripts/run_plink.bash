
#DIR="/mnt/c/users/Nicolas/desktop/prs/results/crianças/scores"
DIR="/mnt/c/users/Nicolas/desktop/prs/results/adultos/scores"
PLINK="/mnt/c/users/Nicolas/desktop/prs/plink"
#OUTDIR="/mnt/c/users/Nicolas/desktop/prs/results/crianças/profiles"
OUTDIR="/mnt/c/users/Nicolas/desktop/prs/results/adultos/profiles"
#BFILE="/mnt/c/Users/Nicolas/Desktop/prs/amostra_alvo/crianças/BANCO_FILTER_ADHD_QC"
BFILE="/mnt/c/Users/Nicolas/Desktop/prs/amostra_alvo/adultos/PSY_GSA1-GSA2_merged_geno0.05_maf0.01_mind0.05_hwe1e-6-FINAL-hg19rsID-bravo-dbSNP155-rm-dup-b"

traits=(
IM
CAD
FA
Hip
IC
Stroke
)

files=(
IM_pst_eff_a1_b0.5_phi1e-02_chr_all.txt
CAD_pst_eff_a1_b0.5_phi1e-02_chr_all.txt
FA_pst_eff_a1_b0.5_phi1e-02_chr_all.txt
Hip_pst_eff_a1_b0.5_phi1e-02_chr_all.txt
IC_pst_eff_a1_b0.5_phi1e-02_chr_all.txt
Stroke_pst_eff_a1_b0.5_phi1e-02_chr_all.txt
)


for i in "${!traits[@]}"
do
    mkdir -p $OUTDIR/${traits[$i]}

    echo "****************************************** ${traits[$i]} **************************************************************"

    "$PLINK" \
    --bfile "$BFILE" \
    --score "$DIR/${traits[$i]}/${files[$i]}" 2 4 6 \
    --out "$OUTDIR/${traits[$i]}/${traits[$i]}"

done
