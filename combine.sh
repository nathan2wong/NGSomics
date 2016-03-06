docker run -w /home/dbdata/trial1/ -ti -v /home/ngsomics:/home/dbdata nathan2wong/ngsomics \
while true; do
                read -p "Do you wish to begin NGSomics on trial 1?" yn
                        case $yn in
                        [Yy]* ) 
                        ####Script begins
#Requires input of "aligned.sam" and "reference.fna"
samtools view -b -S -o aligned.bam aligned.sam; #Converting SAM to BAM
echo "111";
samtools sort -T aligned.sorted -o aligned.sorted.bam aligned.bam; #Sort BAM file
#Variant calling 
echo "222";
samtools mpileup -g -f reference.fna aligned.sorted.bam > variants.bcf;
echo "test";
bcftools view variants.bcf > variants.vcf; #BCF to VCF File 
samtools mpileup -f reference.fna aligned.sorted.bam | java -jar varscan.jar mpileup2snp > variants2.vcf; #Varscan
freebayes -f reference.fna aligned.sorted.bam > variants3.vcf; #Freebayes
echo "333";

vcftools --vcf variants.vcf --gzdiff variants2.vcf --diff-site; #final test
####Script ends

                        break;;
                        [Nn]* ) exit;;
                        *) echo "Please answer yes or no.";;
                esac
        done
\
while true; do
                read -p "Do you wish to remove excess data?" yn
                        case $yn in
                        [Yy]* )
                            rm aligned.bam aligned.sorted.bam out.log reference.fna.fai         variants.bcf variants.vcf variants2.vcf variants3.vcf;
                            while true; do
                                    read -p "Do you wish to view the results now?" yn
                                    case $yn in 
                                    [Yy]* ) cat out.diff.sites_in_files; exit;;
                                    [Nn]* ) echo "Done!"; ls; exit;;
                                    *) echo "Please answer yes or no.";;
                                esac
                            done;;
                        [Nn]* ) echo "Done!"; exit;;
                        *) echo "Please answer yes or no.";;
                esac
        done

