ARG BASE_CONTAINER=whatever
FROM $BASE_CONTAINER

MAINTAINER Aaron Cody <aaron@aaroncody.com>

##---------------------------- PyTorch/fast.ai ----------------------------
USER root

RUN conda install pytorch torchvision cudatoolkit=10.1 -c pytorch

# add this back in later if needed:
#RUN conda uninstall --force jpeg libtiff -y
#RUN conda install -c conda-forge libjpeg-turbo pillow==6.0.0
#RUN CC="cc -mavx2" pip install --no-cache-dir -U --force-reinstall --no-binary :all: --compile pillow-simd

RUN pip install fastai2

RUN sudo apt-get -y update
RUN sudo apt install -y python-pydot python-pydot-ng graphviz

USER $NB_UID