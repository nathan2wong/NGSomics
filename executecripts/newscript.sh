#!/bin/bash
#merge fastq files
cat *.fastq > reference.fastq \
echo "fastq merged"
#bedtools
cat data.bed | awk '{x++; printf "%s\tread%d\n",$0,x}' | bedtools bedtobam -g hg19.genome -i - > aligned.bam \
echo "bedtools aligned"
#Requires input of "aligned.sam" and "reference.fastq"
#samtools view -b -S -o aligned.bam aligned.sam #Converting SAM to BAM
#echo "111"
samtools sort -T aligned.sorted -o aligned.sorted.bam aligned.bam #Sort BAM file
#Variant calling
echo "222"
samtools mpileup -g -f reference.fastq aligned.sorted.bam > variants.bcf
echo "test"
bcftools view variants.bcf > variants.vcf #BCF to VCF File
samtools mpileup -f reference.fna aligned.sorted.bam | java -jar varscan.jar mpileup2snp > variants2.vcf #Varscan
freebayes -f reference.fastq aligned.sorted.bam > variants3.vcf #Freebayes
echo "333"

vcftools --vcf variants.vcf --gzdiff variants2.vcf --diff-site #final test
vcf-merge $(ls -1 *.vcf | perl -pe 's/\n/ /g') >merge.vcf #merge vcf