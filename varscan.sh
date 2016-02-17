#!/bin/bash

#Requires input of "aligned.bam" and "reference.fna"
java -jar VarScan.v2.3.7.jar mpileup2snp -g -f varscandata/genomes/NC_008253.fna varscandata/genomes/sim_reads_aligned.sorted.bam > sim_variants.bcf