#!/bin/bash
#
# This script is run by the dockerfile during the docker build.
#

set -ex

export DEBIAN_FRONTEND=noninteractive

apt-get update

apt-get install -y \
  bash-completion \
  build-essential \
  cmake \
  freeglut3-dev \
  git \
  libboost-all-dev \
  libglew-dev \
  libjpeg-dev \
  libeigen3-dev \
  libopencv-dev \
  libopenni2-dev \
  libqhull-dev \
  libqt4-dev \
  libqwt-dev \
  libsuitesparse-dev \
  libudev-dev \
  libusb-1.0-0-dev \
  libvtk7-dev \
  mesa-utils \
  openjdk-8-jdk \
  zlib1g-dev \
  libyaml-cpp-dev \
  python-dev \
  python-matplotlib \
  python-numpy \
  python-pip \
  python-scipy \
  python-yaml \
  python3-dev \
  python3-matplotlib \
  python3-numpy \
  python3-pip \
  python3-scipy \
  python3-yaml \
  sudo

pip install matplotlib numpy scipy vtk PyYAML

pip3 install vtk pyrealsense2 opency-python

  # optional cleanup to make the docker image smaller
  # rm -rf /var/lib/apt/lists/*
