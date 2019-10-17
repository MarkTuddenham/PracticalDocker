# Adapted from https://hub.docker.com/r/jupyterhub/jupyterhub/dockerfile

FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04

LABEL maintainer="Mark Tuddenham"

# install nodejs, utf8 locale, set CDN because default httpredir is unreliable
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install \
    locales \
    wget \
    curl \
    git \
    bzip2 \
    build-essential \
    && apt-get purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "en_GB.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get update && apt-get install -yq --no-install-recommends \
    nodejs \
    python3-dev \
    python3-pip \
    python3-setuptools \  
    && apt-get purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# # install Python + NodeJS with conda
# RUN wget -q https://repo.continuum.io/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O /tmp/miniconda.sh  && \
#     echo 'e1045ee415162f944b6aebfe560b8fee */tmp/miniconda.sh' | md5sum -c - && \
#     bash /tmp/miniconda.sh -f -b -p /opt/conda && \
#     /opt/conda/bin/conda install --yes -c conda-forge \
#     python=3.6 sqlalchemy tornado jinja2 traitlets requests pip pycurl \
#     nodejs configurable-http-proxy && \
#     /opt/conda/bin/pip install --upgrade pip && \
#     rm /tmp/miniconda.sh
# ENV PATH=/opt/conda/bin:$PATH


# Install Python 3 packages
RUN pip3 install --no-cache-dir -U \
    pip \
    wheel \
    # jupyter \
    # 'jupyterlab>=1.0.0' \
    notebook \
    jupyterhub \
    numpy \
    six \
    pandas \
    Pillow \
    opencv-python \
    ipywidgets \
    numexpr  \
    matplotlib \
    scipy \
    seaborn \
    scikit-learn \
    scikit-image \
    cython \
    h5py \
    torch \
    torchvision \
    tensorflow-gpu \
    sqlalchemy \
    tornado \
    jinja2 \
    traitlets \
    requests \
    pycurl 


RUN npm install -g configurable-http-proxy


# Configure environment
ENV SHELL=/bin/bash \
    LC_ALL=en_GB.UTF-8 \
    LANG=en_GB.UTF-8 \
    LANGUAGE=en_GB.UTF-8 \
    PATH=/:${PATH} \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64/:${LD_LIBRARY_PATH}

# # Add Tini
# ENV TINI_VERSION v0.18.0
# ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
# RUN chmod +x /tini
# ENTRYPOINT ["tini", "-g", "--"]

# ADD . /src/jupyterhub
# WORKDIR /src/jupyterhub

# RUN pip install . && \
#     rm -rf $PWD ~/.cache ~/.npm

RUN mkdir -p /srv/jupyterhub/
WORKDIR /srv/jupyterhub/
EXPOSE 8000

LABEL org.jupyter.service="jupyterhub"

CMD ["jupyterhub"]