while true; do
                read -p "Do you wish to begin NGSomics on trial 1?" yn
                        case $yn in
                        [Yy]* ) sh script.sh; break;;
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
