# Build Ubuntu Docker images with CUDA and ROS

## Use

1. Edit Dockerfile to specify CUDA version in base image.

1. Edit Dockerfile to specify ROS version.

1. Edit build.sh to specify build requirements and image name.
    - Edit `<image name>` and `<image tag>`

1. `./build.sh`