#!/bin/bash
#
# Usage:  ./docker_run.sh [/path/to/data]
#
# This script starts the labelfusion Docker container with an interactive bash session.
# If the Docker image is not built, it will automatically build the image from the
# labelfusion.dockerfile before running the container.
#
# Ensure that the Dockerfile is located in the same directory as this script, or adjust
# the path to the Dockerfile accordingly.

# Name of the Docker image (using the locally built image)
image_name=labelfusion:whizhou

# Path to the Dockerfile
dockerfile_path="labelfusion.dockerfile"

# Get the source directory (parent directory of the script)
source_dir=$(cd $(dirname "$0")/.. && pwd)

# Check if the Docker image exists
if ! docker image inspect $image_name > /dev/null 2>&1; then
  echo "Docker image '$image_name' not found. Building the image..."
  
  # Build the Docker image
  # docker build -f "$dockerfile_path" -t $image_name .
  
  # if [ $? -ne 0 ]; then
  #   echo "Error: Docker image build failed."
  #   exit 1
  # fi
  
  # echo "Docker image '$image_name' built successfully."
else
  echo "Docker image '$image_name' found."
fi

# Check if a data directory was provided as an argument
data_mount_arg=""
if [ -n "$1" ]; then
  data_dir=$1
  if [ ! -d "$data_dir" ]; then
    echo "Error: Directory does not exist: $data_dir"
    exit 1
  fi

  data_mount_arg="-v $data_dir:/root/labelfusion/data"
fi

# Allow Docker to access the X server (for GUI applications)
xhost +local:root

# Run the Docker container with necessary mounts and environment variables
docker run --runtime=nvidia -it -e DISPLAY -e QT_X11_NO_MITSHM=1 \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v "$source_dir:/root/labelfusion" \
  $data_mount_arg \
  --privileged \
  -v /dev/bus/usb:/dev/bus/usb \
  $image_name

# Revoke Docker's access to the X server
xhost -local:root
