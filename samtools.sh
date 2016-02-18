#!/bin/bash

#Requires input of "aligned.sam" and "reference.fna"
./samtools view -b -S -o aligned.bam aligned.sam #Converting SAM to BAM
echo "111"
./samtools sort -T aligned.sorted -o aligned.sorted.bam aligned.bam #Sort BAM file
#Variant calling 
echo "222"
./samtools mpileup -g -f reference.fna aligned.sorted.bam > variants.bcf & 
./bcftools call -c -v variants.bcf > variants.vcf #BCF to VCF File 
./samtools mpileup -f reference.fna aligned.sorted.bam | java -jar VarScan.v2.3.7.jar mpileup2snp > variants2.vcf #Varscan

echo "333"


#./samtools tview variants.vcf #view output