# Specify base CUDA image from NVIDIA. 
## See "Overview of Images" at https://hub.docker.com/r/nvidia/cuda for differences between image types (base, runtime, devel).
## Search available images at https://hub.docker.com/r/nvidia/cuda/tags

FROM nvidia/cuda:11.6.2-runtime-ubuntu18.04

SHELL ["/bin/bash", "-c"]

# Configure timezone and locale
RUN echo "Etc/UTC" > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN apt-get update && \
    apt-get install -yq --no-install-recommends tzdata locales && \
    rm -rf /var/lib/apt/lists/*
RUN dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# Install apt dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    lsb-release

# Install ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
## Select one install version. Ensure ROS version is compatible with ubuntu version
## ROS, rqt, rviz, robot-generic libraries, 2D/3D simulators and 2D/3D perception
# RUN apt-get update && apt-get install -y \
    # ros-melodic-desktop-full
## ROS, rqt, rviz, robot-generic libraries
RUN apt-get update && apt-get install -y \
    ros-melodic-desktop
## no GUI tools
# RUN apt-get update && apt-get install -y \
    # ros-melodic-ros-base

# Setup ROS environment
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

# Install dependencies
## Amend accordingly based on requirement
RUN apt-get install -y \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
&& rm -rf /var/lib/apt/lists/*

# Final cleanup
RUN apt-get update && apt-get autoremove -y && apt-get autoclean -y