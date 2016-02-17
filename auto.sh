#!/bin/bash

#Requires input of "aligned.bam" and "reference.fna"
samtools view -b -S -o aligned.bam aligned.sam #Converting SAM to BAM
samtools sort aligned.bam aligned.sorted #Sort BAM file
samtools mpileup -g -f reference.fna aligned.bam > variants.bcf #Variant calling
bcftools call -c -v variants.bcf > variants.vcf #BCF to VCF File
samtools tview variants.vcf #view output