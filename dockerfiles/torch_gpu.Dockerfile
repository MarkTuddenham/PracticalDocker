# Copyright (c) Mark Tuddenham
# FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04

LABEL maintainer="Mark Tuddenham"

RUN apt-get update && apt-get install -yq --no-install-recommends \
    locales \
    build-essential \
    git \
    wget \
    curl \
    && apt-get purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get update && apt-get install -yq --no-install-recommends \
    nodejs \
    python3-dev \
    python3-pip \
    python3-setuptools \  
    && apt-get purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "en_GB.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV SHELL=/bin/bash \
    LC_ALL=en_GB.UTF-8 \
    LANG=en_GB.UTF-8 \
    LANGUAGE=en_GB.UTF-8 \
    PATH=/:${PATH} \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64/:${LD_LIBRARY_PATH}

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["tini", "-g", "--"]


# Install Python 3 packages
RUN pip3 install --no-cache-dir -U \
    pip \
    wheel \
    jupyter \
    'jupyterlab>=1.0.0' \
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
    torchvision

# Activate ipywidgets extension in the environment that runs the notebook server
RUN jupyter notebook --generate-config  && \
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    npm cache clean --force && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp

EXPOSE 8888
WORKDIR /docs

# Configure container startup
CMD ["start.sh"]

# Add local files as late as possible
COPY context/start.sh /usr/local/bin/
COPY context/jupyter_notebook_config.py /etc/jupyter/