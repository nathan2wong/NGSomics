#!/bin/bash

samtools index example.bam &
samtools tview example.bam -a 

gatk 