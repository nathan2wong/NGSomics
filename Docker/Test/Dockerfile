FROM debian:jessie

MAINTAINER Stephen Newhouse stephen.j.newhouse@gmail.com

LABEL Description="This is the debian:jessie base image for compbio ngseasy builds. This is Fat Dev Box Image to help get around the dependency mess of all the components" NickName="little-fatty-deb"

ENV DEBIAN_FRONTEND noninteractive

# set R version
# https://github.com/rocker-org/rocker/blob/master/r-base/Dockerfile#L38
ENV R_BASE_VERSION 3.2.3

# Remain current, upgrade apt-get, add build tools, R, JAVA and python
RUN sed -i '$adeb http://cran.ma.imperial.ac.uk/bin/linux/debian jessie-cran3/' /etc/apt/sources.list && \
  apt-key adv --keyserver keys.gnupg.net --recv-key 381BA480 && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get dist-upgrade -y && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  apt-get purge && \
  apt-get install -y --no-install-recommends \
  apt-utils && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  apt-get purge && \
# ant \
# asciidoc \
  apt-get install -y --no-install-recommends \
  automake \
  bash \
  binutils \
  build-essential \
  bzip2 \
#  ca-certificates \
  cmake \
  curl \
  dkms \
  dpkg-dev \
  debconf \
  gcc \
  g++ \
  gpp \
  gcc \
  git \
  git-core \
  gfortran \
  gnuplot \
  gradle \
  graphviz \
# htop \
  less \
  libatlas-dev \
  libblas-dev \
  libbz2-dev \
  libc-bin \
  libconfig-dev \
  libcurl4-openssl-dev \
  libfreetype6-dev \
  liblapack-dev \
  liblzma-dev \
  libpcre3-dev \
  libpng-dev \
  libreadline-dev \
  libssl-dev \
  libxml2-dev \
  libxml2-utils \
  llvm \
  locales \
  make \
  ncurses-dev \
#  openssl \
#  openssl-blacklist \
  parallel \
  pkg-config \
  python \
  python-dev \
  python2.7-dev \
  python-pip \
  python-yaml \
#  ssl-cert \
#  sudo \
  tabix \
  time \
  tree \
  unzip \
  vim \
  wget \
  zlib1g && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  apt-get purge && \
# java
#  JAVA_INSTALL_VERSION="8" && \
#  apt-get install -y --no-install-recommends \
#  openjdk-${JAVA_INSTALL_VERSION}-jre \
#  openjdk-${JAVA_INSTALL_VERSION}-jdk && \
#  apt-get update && \
#  apt-get upgrade -y && \
#  apt-get autoremove -y && \
#  apt-get autoclean && \
#  apt-get clean && \
#  apt-get purge && \
# Install R
# https://github.com/rocker-org/rocker/blob/master/r-base/Dockerfile#L45
  apt-get install -y --no-install-recommends \
  libatlas3-base \
  libopenblas-base && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  apt-get purge && \
  apt-get install -y --no-install-recommends \
  r-base=${R_BASE_VERSION}* \
  r-base-dev=${R_BASE_VERSION}* \
  r-recommended=${R_BASE_VERSION}* && \
# littler && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  apt-get purge && \
# python modules scipy stack
  apt-get install -y  --no-install-recommends \
  python-biopython \
  python-numpy \
  python-scipy \
  python-matplotlib \
  python-reportlab \
  python-pandas \
  python-sympy \
  python-tk \
  python-nose && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  apt-get purge && \
# install cython
  CYTHON_VERSION="0.23" && \
  cd /tmp && \
  wget http://cython.org/release/Cython-${CYTHON_VERSION}.tar.gz && \
  tar xvf Cython-${CYTHON_VERSION}.tar.gz && \
  chmod -R 755 Cython-${CYTHON_VERSION} && \
  cd Cython-${CYTHON_VERSION} && \
  python setup.py install && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  apt-get purge && \

# Ensure permissions are set for update in place by arbitrary users
# From: https://github.com/chapmanb/bcbio-nextgen/blob/master/Dockerfile#L68
  find /usr/local -perm /u+x -execdir chmod a+x {} \; && \
  find /usr/local -perm /u+w -execdir chmod a+w {} \; && \

# clean up
  apt-get update && \
  apt-get update -y && \
  apt-get clean && \
  apt-get autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/* && \
  rm -rf /var/tmp/* && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/ && \

# Create a user:ngseasy and group:ngseasy
  useradd -m -U -s /bin/bash ngseasy && \
  cd /home/ngseasy && \
  usermod -aG sudo ngseasy && \

# make dirs: /usr/local/ngs/bin and sort permissions out
  mkdir /usr/local/ngs && \
  mkdir /usr/local/ngs/bin && \
  chown ngseasy:ngseasy /usr/local/ngs/bin  && \
  chmod -R 755 /usr/local/ngs/bin  && \
  chown -R ngseasy:ngseasy /usr/local/ngs/bin \

# configure locales
RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8 && \
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# set JAVA_HOME
# ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64

# Use baseimage-docker's bash.
CMD ["/bin/bash"]

# base image
FROM compbio/ngseasy-base:a1.0-002

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
 RUN useradd -m -U -s /bin/bash ngsomics && \
  cd /home/ngsomics && \
  usermod -aG sudo ngsomics && \
  make dirs: /usr/local/ngs/bin and sort permissions out \
  mkdir /usr/local/ngs && \
  mkdir /usr/local/ngs/bin && \
  chown ngsomics:ngsomics /usr/local/ngs/bin  && \
  chmod -R 755 /usr/local/ngs/bin  && \
  chown -R ngsomics:ngsomics /usr/local/ngs/bin && \
  sed -i '$aPATH=$PATH:/usr/local/ngs/bin' /home/ngsomics/.bashrc && \
  bash -c "source /home/ngsomics/.bashrc" \

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
  cd /usr/local/ngs/bin && \
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
  cd /usr/local/ngs/bin && \
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
  bash -c "source /home/ngsomics/.bashrc" && \

# Clean up APT when done.
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  apt-get autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}\

ADD fix_ambiguous /usr/local/bin/ \

# PERMISSIONS
RUN chmod -R 755 /usr/local/ngs/bin && \
  chown -R ngsomics:ngsomics /usr/local/ngs/bin \

# run as non root user ngsomics
 ENV HOME /home/ngsomics \
 ENV PATH /usr/local/ngs/bin:/usr/local/bin:$PATH \
 USER ngsomics \
 WORKDIR /home/ngsomics \
 VOLUME /home/ngsomics/ngs_projects \
 CMD ["/bin/bash"] \