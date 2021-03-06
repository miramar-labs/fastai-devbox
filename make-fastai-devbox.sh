#!/usr/bin/env bash

TAG=v1.0
NVIDIA_CUDA_VER=10.1-cudnn7-runtime-ubuntu18.04
#PYTHON_VER=3.6.5
PYTHON_VER=default
FASTAI_BASE=fastai/datascience-notebook:$TAG

read -p "Build COMPLETE - would you like to do a clean build of the base notebooks? (Y/N)?  `echo $'\n> '`" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # Clean up intermediate containers:
  docker rmi fastai/datascience-notebook:$TAG
  docker rmi fastai/scipy-notebook:$TAG
  docker rmi fastai/minimal-notebook:$TAG
  docker rmi fastai/base-notebook:$TAG

  # Clean up docker-stacks sources
  rm -rf docker-stacks

  # get latest docker-stacks
  git clone git@github.com:jupyter/docker-stacks.git

  # Build base container with GPU support by basing it off nvidia/cuda:
  pushd docker-stacks/base-notebook
  docker build --build-arg PYTHON_VERSION=$PYTHON_VER --build-arg BASE_CONTAINER=nvidia/cuda:$NVIDIA_CUDA_VER -t fastai/base-notebook:$TAG -f Dockerfile .
  popd

  # Build interim containers, inheriting from the base-notebook:
  pushd docker-stacks/minimal-notebook
  docker build --build-arg BASE_CONTAINER=fastai/base-notebook:$TAG -t fastai/minimal-notebook:$TAG -f Dockerfile .
  popd

  pushd docker-stacks/scipy-notebook
  docker build --build-arg BASE_CONTAINER=fastai/minimal-notebook:$TAG -t fastai/scipy-notebook:$TAG -f Dockerfile .
  popd

  pushd docker-stacks/datascience-notebook
  docker build --build-arg BASE_CONTAINER=fastai/scipy-notebook:$TAG -t fastai/datascience-notebook:$TAG -f Dockerfile .
  popd

fi

read -p "Base Build COMPLETE - would you like build the fast.ai container? (Y/N)? `echo $'\n> '`" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # Build the final fastai-dev container:
  echo docker build --build-arg BASE_CONTAINER=$FASTAI_BASE -t fastai/fastai-devbox:$TAG -f Dockerfile .
  docker build --build-arg BASE_CONTAINER=$FASTAI_BASE -t fastai/fastai-devbox:$TAG -f Dockerfile .
fi

read -p "ALL DONE - would you like to clean up any intermediate files? (Y/N)? `echo $'\n> '`" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # Clean up intermediate containers:
  docker rmi fastai/datascience-notebook:$TAG
  docker rmi fastai/scipy-notebook:$TAG
  docker rmi fastai/minimal-notebook:$TAG
  docker rmi fastai/base-notebook:$TAG

  # Clean up docker-stacks sources
  rm -rf docker-stacks
fi
