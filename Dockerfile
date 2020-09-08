FROM civisanalytics/datascience-r:4.0.1
MAINTAINER support@civisanalytics.com

ENV DEFAULT_KERNEL=ir \
    TINI_VERSION=v0.16.1 \
    CIVIS_JUPYTER_NOTEBOOK_VERSION=2.0.0

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
        libcurl4 && \
        apt-get clean -y && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# instead of virtual env, just use python3.7 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

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
