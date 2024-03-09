# Get repository
distribution=$(. /etc/os-release;echo  $ID$VERSION_ID) 
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia container toolkit
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Test installation
usr/local/cuda/bin/nvcc --version # Check cuda version
docker run -it --gpus all nvidia/cuda:12.3.0-base-ubuntu20.04 nvidia-smi