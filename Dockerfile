FROM civisanalytics/datascience-r:3.3.0
MAINTAINER support@civisanalytics.com

ENV DEFAULT_KERNEL=ir \
    TINI_VERSION=v0.16.1 \
    CIVIS_JUPYTER_NOTEBOOK_VERSION=1.0.2

# for python3.7
RUN echo 'deb http://ftp.debian.org/debian stable main' >> /etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y  && \
    apt-get install -y --no-install-recommends \
        wget \
        fonts-dejavu \
        gfortran \
        vim \
        nano \
        emacs \
        gcc  \
        build-essential \
        python3.7 \
        python3-pip \
        python3-setuptools \
        libcurl3 && \
        apt-get clean -y && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# instead of virtual env, just use python3.7 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

# Install Tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# needed for some system package
# TODO: investigate
RUN ln -s /bin/tar/ /bin/gtar

RUN pip3 install wheel && \
    pip3 install civis-jupyter-notebook==${CIVIS_JUPYTER_NOTEBOOK_VERSION} \
      cbor2==4.1.2 && \
    civis-jupyter-notebooks-install

COPY ./setup.R /setup.R
RUN Rscript setup.R

EXPOSE 8888
WORKDIR /root/work

ENTRYPOINT ["/tini", "--"]
CMD ["civis-jupyter-notebooks-start"]
