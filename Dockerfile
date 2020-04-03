ARG BASE_CONTAINER=whatever
FROM $BASE_CONTAINER

MAINTAINER Aaron Cody <aaron@aaroncody.com>

##---------------------------- PyTorch/fast.ai ----------------------------
USER root

# enable sudo
RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook

# Various utils
RUN apt-get update -y
RUN apt-get install -y apt-utils openssh-server iputils-ping netcat curl vim tree gcc

# install pytorch/cuda
RUN conda install pytorch torchvision cudatoolkit=10.1 -c pytorch

# add this back in later if needed:
#RUN conda uninstall --force jpeg libtiff -y
#RUN conda install -c conda-forge libjpeg-turbo pillow==6.0.0
#RUN CC="cc -mavx2" pip install --no-cache-dir -U --force-reinstall --no-binary :all: --compile pillow-simd

# install fastai
RUN pip install fastai2

RUN sudo apt install -y python-pydot python-pydot-ng graphviz

#RUN conda install pyarrow
RUN pip install pydicom kornia opencv-python scikit-image

RUN conda install --quiet --yes -c conda-forge xeus-python=0.6.12 ptvsd

# JLab user extensions
RUN jupyter labextension install @jupyterlab/debugger
#RUN jupyter labextension install jupyterlab-drawio
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@^2.0.0 --no-build
RUN jupyter labextension install @bokeh/jupyter_bokeh@^2.0.0 --no-build
RUN jupyter labextension install jupyter-matplotlib@^0.7.2 --no-build
RUN jupyter labextension install jupyterlab-kernelspy

USER $NB_UID