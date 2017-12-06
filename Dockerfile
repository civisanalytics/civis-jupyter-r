FROM rocker/verse:3.4.2
MAINTAINER support@civisanalytics.com

ENV DEFAULT_KERNEL=ir \
    TINI_VERSION=v0.16.1 \
    CIVIS_JUPYTER_NOTEBOOK_VERSION=0.2.2

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y --no-install-recommends && \
    apt-get install -y --no-install-recommends \
        curl \
        wget \
        fonts-dejavu \
        gfortran \
        python-dev \
        gcc &&  \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install pip
RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    pip install --upgrade pip setuptools && \
    rm -rf ~/.cache/pip && \
    rm -f get-pip.py

# Install Tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# needed for some system package
# TODO: investigate
RUN ln -s /bin/tar/ /bin/gtar

RUN pip install git+https://github.com/civisanalytics/civis-jupyter-notebook.git@5ff00365dd4a8b92d261d652693d3d7d3a75141f && \
    civis-jupyter-notebooks-install

COPY ./setup.R /setup.R
RUN Rscript setup.R

EXPOSE 8888
WORKDIR /root/work

ENTRYPOINT ["/tini", "--"]
CMD ["civis-jupyter-notebooks-start"]
