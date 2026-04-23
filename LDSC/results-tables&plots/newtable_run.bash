#!/bin/bash

OUTPUT="rg_long.tsv"

echo -e "p1\tp2\trg\tse\tz\tp\th2_liab\th2_liab_se\th2_int\th2_int_se\tgcov_int\tgcov_int_se" > "$OUTPUT"

awk '
BEGIN {
    OFS="\t"
}

FNR==1 {
    flag=0
}

/Summary of Genetic Correlation Results/ {
    flag=1
    next
}

/Analysis finished/ {
    flag=0
}

flag && NF>5 {

    if ($1=="p1") next

    gsub("_hm3_munge.sumstats.gz","",$1)
    gsub("_hm3_munge.sumstats.gz","",$2)

    if ($1==$2) next

    if ($1 < $2)
        key=$1"_"$2
    else
        key=$2"_"$1

    if (!seen[key]) {
        seen[key]=1
        print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12
    }
}
' *.log >> "$OUTPUT"
