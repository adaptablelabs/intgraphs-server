FROM rocker/r-ubuntu:18.04

#
LABEL maintainer="LEI SHI <foxshee@gmail.com>"

# Install Basic components and Python 3
RUN apt-get update \
      && apt-get install -y --no-install-recommends apt-utils \
      && apt-get install -y --no-install-recommends \
          curl software-properties-common \
          build-essential libcurl4-openssl-dev libnss3-dev libssl-dev \
          git \
          ssh wget

# Install Python via source code
RUN apt-get update \
      && apt-get install -y --no-install-recommends \
            zlib1g-dev libncurses5-dev libgdbm-dev libreadline-dev libffi-dev wget \
      && cd /tmp && wget --no-check-certificate https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tar.xz \
      && tar -xf Python-3.7.2.tar.xz \
      && cd Python-3.7.2 \
      && ./configure --enable-optimizations \
      && make -j 1 \
      && make altinstall \
      && cd /usr/local/bin \
      && ln -s /usr/bin/python3 python \
#       && pip3 install --upgrade pip \
#       && pip install --upgrade pip

# Install Python by `deadsnakes PPA`
#   - Currently, this way is not working....
# RUN add-apt-repository --enable-source --yes "ppa:deadsnakes/ppa" && apt-get update \
#       && apt-get install -y --no-install-recommends \
#       python3.7 python3-pip python3-setuptools python3-dev \
#       && cd /usr/local/bin \
#       && ln -s /usr/bin/python3 python \
#       && whereis pip3 \
#       && pip3 install --upgrade pip \
#       && pip install --upgrade pip

# Install Conda (Anaconda)
# Ref - http://www.science.smith.edu/dftwiki/index.php/Tutorial:_Docker_Anaconda_Python_--_4
RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh \
      && bash Anaconda3-5.0.1-Linux-x86_64.sh -b \
      && rm Anaconda3-5.0.1-Linux-x86_64.sh
ENV PATH /root/anaconda3/bin:$PATH
RUN conda update conda

# Add needed scripts
ADD ./ /intgraphs_server
ADD ./containers/intgraphs_cron/init.sh /init.sh
ADD ./containers/intgraphs_cron/entrypoint.sh /entrypoint.sh
RUN chmod a+x /init.sh  \
      && chmod a+x /entrypoint.sh \
      && chmod a+x -R /intgraphs_server/scripts

# Install "init" packages
RUN sh /init.sh && rm /init.sh

# Install R Packages
RUN cd /intgraphs_server/apps/intgraphs \
      # Restart the 'bash'
      && eval "$(conda shell.bash hook)" \
      && sh run-pkg-installer.sh

# Run `entrypoint`
# Add the wait script to the image
# Ref - https://github.com/ufoscout/docker-compose-wait
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.3.0/wait /wait
RUN chmod +x /wait

# ENTRYPOINT ["./entrypoint.sh"]
CMD wait && /entrypoint.sh
