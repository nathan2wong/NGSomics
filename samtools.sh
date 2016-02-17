#!/bin/bash

#Requires input of "aligned.sam" and "reference.fna"
./samtools view -b -S -o aligned.bam aligned.sam #Converting SAM to BAM
echo "111"
./samtools sort aligned.bam aligned.sorted #Sort BAM file
#Variant calling 
echo "222"
./samtools mpileup -g -f reference.fna aligned.bam > variants.bcf & 
java -jar VarScan.v2.3.7.jar mpileup2snp -g -f reference.fna varscandata/genomes/sim_reads_aligned.sorted.bam > sim_variants.bcf

echo "333"

#bcftools call -c -v variants.bcf > variants.vcf #BCF to VCF File
#./samtools tview variants.vcf #view output