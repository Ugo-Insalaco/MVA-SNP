# Reproducible Scultpted neural points
Adaptation of the [SNP code](https://github.com/princeton-vl/SNP) to make it reproducible and more resilient to version changes.
This code uses one container to run the python scripts and one container for creating custom datasets using colmap. It also gives a jupyter notebook in order to generate new cameras automatically in a circle around a given camera.

# Requirements
- Nvidia graphic card with CUDA installed (you can follow [this](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html) page)
- Docker installed (follow tutorial [here](https://docs.docker.com/engine/install/ubuntu) for ubuntu machines)
- NVidia container toolkit (tutorial [here](https://saturncloud.io/blog/how-to-install-pytorch-on-the-gpu-with-docker/)) Alternativerly you can run the scripts in base_setups to install Docker and the NVidia container toolkit
- pip version or installed version of gdown
- git
- Jupter notebook

# Setup
Place yourself in the MVA-SNP folder then run the setup_snp.sh file. This will in order:
- Install gdown
- Download the SNP code 
- Patch it with this project's modifications 
- Build the Docker image for SNP
- Create the Docker container.

The container will later be used to run every python command associated with the project

# Custom dataset
To create a DTU dataset based on your own images:
- Add a <SCENE>/images folder in the "custom_data" folder with your own images of the same scene from multiple views
- Run the setup_colmap.sh file to create the colmap container which will run the Sfm-MVS preprocessing functions
- Run the custom_dataset.sh file to create the custom dataset. Output will be located in your <SCENE> folder under DTU_format.

# Notes:
- the docker image can be large, to empty the docker cache use
```
docker builder prune
```