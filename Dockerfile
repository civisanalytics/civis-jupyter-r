ARG BUILDPLATFORM=linux/x86_64
FROM --platform=${BUILDPLATFORM} civisanalytics/datascience-r:6.0.0
LABEL org.opencontainers.image.authors="support@civisanalytics.com"

ENV DEFAULT_KERNEL=ir \
    TINI_VERSION=v0.19.0 \
    CIVIS_JUPYTER_NOTEBOOK_VERSION=2.2.0

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

# instead of virtual env, just use python3 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Install Tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

RUN pip3 install civis-jupyter-notebook==${CIVIS_JUPYTER_NOTEBOOK_VERSION} && \
    civis-jupyter-notebooks-install

COPY ./setup.R /setup.R
RUN Rscript setup.R

EXPOSE 8888
WORKDIR /root/work

ENTRYPOINT ["/tini", "--"]
# Hide the banner about Notebook 7 migration
# (cf. https://discourse.jupyter.org/t/how-to-disable-message-banner-in-notebook-6-5-4/19422/2)
CMD ["civis-jupyter-notebooks-start", "--NotebookApp.show_banner=False"]
