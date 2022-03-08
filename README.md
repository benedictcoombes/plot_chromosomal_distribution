# plot_chromosomal_distribution
 
Source software
```
source bedtools-2.28.0
source samtools-1.4
```

Specify input file (two column tsv file with chromosome name and position)
```
input_file=gene_positions.tsv
prefix=gene_positions
```

Produce bed files for RefSeqv1.0 with 1Mbp and 10Mbp windows. These can be modified depending on the use case. Sliding windows can be introduced using -s but can lead to a messy plot. Fixed windows becomes a problem if features are overlapping different windows but for assessing overall distribution patterns fixed windows are usually appropriate. Sliding windows best if trying to precisely pinpoint the junction of a genomic feature such as a deletion or introgression
```
samtools faidx 161010_Chinese_Spring_v1.0_pseudomolecules.fasta
awk '{OFS="\t"; print $1,$2}' 161010_Chinese_Spring_v1.0_pseudomolecules.fasta.fai > RefSeqv1.0_genome_file.txt
bedtools makewindows -w 1000000 -g RefSeqv1.0_genome_file.txt > RefSeqv1.0_1Mb_windows.bed
bedtools makewindows -w 10000000 -g RefSeqv1.0_genome_file.txt > RefSeqv1.0_10Mb_windows.bed
```

Convert input file into bed format
```
awk '{OFS="\t"; print $1,$2,$2+1}' $input_file > ${prefix}.bed
```

Produce coverage files
```
bedtools coverage -a RefSeqv1.0_1Mb_windows.bed -b ${prefix}.bed | cut -f 1,2,4 > ${prefix}_1Mb_windows.tsv
bedtools coverage -a RefSeqv1.0_10Mb_windows.bed -b ${prefix}.bed | cut -f 1,2,4 > ${prefix}_10Mb_windows.tsv
```

Plot distribution
```
Rscript plot_chromosomal_distribution.R gene_overlap_positions_1Mb_windows.tsv ${prefix}_1Mb_windows.png
Rscript plot_chromosomal_distribution.R gene_overlap_positions_10Mb_windows.tsv ${prefix}_10Mb_windows.png
```

