# base image
FROM compbio/ngseasy-base

# Maintainer
MAINTAINER Nathan Wong nathan2wong@gmail.com

LABEL Description="This is the NGSomics Pipeline" NickName="jojobirdie"

# Remain current and get random dependencies
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y --no-install-recommends \
  man \
  bison \
  flex \
  byacc \
  zlib1g-dev \
  libncurses5-dev && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  apt-get purge && \

# Create a user:ngsomics and group:ngsomics
# RUN useradd -m -U -s /bin/bash ngsomics && \
#  cd /home/ngsomics && \
#  usermod -aG sudo ngsomics && \
#  make dirs: /usr/local/ngs/bin and sort permissions out
#  mkdir /usr/local/ngs && \
#  mkdir /usr/local/ngs/bin && \
#  chown ngsomics:ngsomics /usr/local/ngs/bin  && \
#  chmod -R 755 /usr/local/ngs/bin  && \
#  chown -R ngsomics:ngsomics /usr/local/ngs/bin && \
#  sed -i '$aPATH=$PATH:/usr/local/ngs/bin' /home/ngsomics/.bashrc && \
#  bash -c "source /home/ngsomics/.bashrc"

## NGS Tools -------------------------------------------------------------------
# samtools, htslib, bcftools
RUN cd /usr/local/ngs/bin && \
  git clone --branch=develop git://github.com/samtools/htslib.git && \
  git clone --branch=develop git://github.com/samtools/bcftools.git && \
  git clone --branch=develop git://github.com/samtools/samtools.git && \
  cd /usr/local/ngs/bin/htslib && \
  autoconf && \
  ./configure  && \
  make && \
  make install && \
  cd /usr/local/ngs/bin/bcftools && \
  make && \
  make install && \
  cd /usr/local/ngs/bin/samtools && \
  make && \
  make install && \
  cd /usr/local/ngs/bin && \
  rm -r bcftools && \
  rm -r htslib && \
  rm -r samtools && \

# vcftools https://github.com/vcftools/vcftools
  cd /usr/local/ngs/bin/ && \
  git clone https://github.com/vcftools/vcftools.git && \
  cd vcftools && \
  ./autogen.sh && \
  ./configure && \
  make && \
  make install && \
  cd /usr/local/ngs/bin/ && \
  rm -r ./vcftools && \

# vcflib
  cd /usr/local/ngs/bin/ && \
  rm -rfv /usr/local/ngs/bin/vcflib && \
  git clone --recursive git://github.com/ekg/vcflib.git && \
  cd vcflib && \
  make && \
  chmod -R 755 ./bin/ && \
  cp -v ./bin/* /usr/local/bin/ && \
  cd /usr/local/ngs/bin/ && \
  rm -r ./vcflib && \

## Aligners --------------------------------------------------------------------
# bwakit
# http://sourceforge.net/projects/bio-bwa/files/bwakit/
RUN cd /usr/local/ngs/bin && \
  BWA_VERSION="0.7.12" && \
  wget \
  http://sourceforge.net/projects/bio-bwa/files/bwakit/bwakit-${BWA_VERSION}_x64-linux.tar.bz2 && \
  tar xjvf bwakit-${BWA_VERSION}_x64-linux.tar.bz2 && \
  chmod -R 755 /usr/local/ngs/bin && \
  ln -s /usr/local/ngs/bin/bwa.kit/bwa /usr/local/bin/bwa && \
  cd /usr/local/ngs/bin && \
  rm bwakit-${BWA_VERSION}_x64-linux.tar.bz2 && \

# novoalign: need to add novoalign.lic
  NOVOALIGN_VERSION="V3.03.02" && \
  cd /usr/local/ngs/bin && \
  wget https://s3-eu-west-1.amazonaws.com/novoalign/novocraft${NOVOALIGN_VERSION}.Linux3.0.tar.gz && \
  tar xvf novocraft${NOVOALIGN_VERSION}.Linux3.0.tar.gz && \
  chmod -R 755 novocraft && \
  cp -vr novocraft/* /usr/local/bin/ && \
  cd /usr/local/ngs/bin/ && \
  rm -r novocraft && \
  rm novocraft${NOVOALIGN_VERSION}.Linux3.0.tar.gz && \

# bowtie2
  BOWTIE2_VERSION="2.2.6" && \
  cd /usr/local/ngs/bin && \
  wget http://sourceforge.net/projects/bowtie-bio/files/bowtie2/${BOWTIE2_VERSION}/bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip && \
  unzip bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip && \
  cd bowtie2-${BOWTIE2_VERSION} && \
  chmod -R 755 ./ && \
  cp -v bowtie2* /usr/local/bin/ && \
  cp -r scripts /usr/local/ngs/bin/bowtie2_scripts && \
  cd /usr/local/ngs/bin/ && \
  rm -r bowtie2-${BOWTIE2_VERSION} && \
  rm bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip && \


## Variant Calling -------------------------------------------------------------
# freebayes
RUN cd /usr/local/ngs/bin && \
  git clone --recursive git://github.com/ekg/freebayes.git && \
  cd /usr/local/ngs/bin/freebayes && \
  make && \
  chmod -R 755 /usr/local/ngs/bin/freebayes && \
  sed -i '$aPATH=${PATH}:/usr/local/ngs/bin/freebayes/bin' /home/ngsomics/.bashrc && \
  cp -v /usr/local/ngs/bin/freebayes/bin/* /usr/local/bin && \
  cp -v /usr/local/ngs/bin/freebayes/scripts/* /usr/local/bin && \
  cd /usr/local/ngs/bin/ && \
  rm -r freebayes && \

# Platypus VERSION := 0.8.1
  cd /usr/local/ngs/bin && \
  git clone --recursive https://github.com/andyrimmer/Platypus.git && \
  chmod -R 755 Platypus && \
  cd Platypus && \
  make && \
  chmod -R 755 ./* && \
  cp -vrf ./bin/* /usr/local/bin && \
  cp -vrf ./scripts/* /usr/local/bin && \
  cp -v ./*.py /usr/local/bin && \
  cd /usr/local/ngs/bin/ && \
  rm -r Platypus && \

# varscan
  VARSCAN_VERSION="v2.3.9" && \
  cd /usr/local/ngs/bin && \
  wget http://sourceforge.net/projects/varscan/files/VarScan.${VARSCAN_VERSION}.jar && \
  chmod -R 755 VarScan.${VARSCAN_VERSION}.jar && \
  ln -s VarScan.${VARSCAN_VERSION}.jar varscan.jar && \


# source .bashrc
RUN  bash -c "source /home/ngsomics/.bashrc" && \

# Clean up APT when done.
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  apt-get autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

ADD fix_ambiguous /usr/local/bin/

# PERMISSIONS
RUN chmod -R 755 /usr/local/ngs/bin && \
  chown -R ngsomics:ngsomics /usr/local/ngs/bin

# run as non root user ngsomics
ENV HOME /home/ngsomics
ENV PATH /usr/local/ngs/bin:/usr/local/bin:$PATH
USER ngsomics
WORKDIR /home/ngsomics
VOLUME /home/ngsomics/ngs_projects
CMD ["/bin/bash"]