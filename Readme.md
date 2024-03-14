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
Place yourself in the MVA-SNP folder then run the **setup_snp.sh** file. This will in order:
- Install gdown
- Download the SNP code 
- Patch it with this project's modifications 
- Build the Docker image for SNP
- Create the Docker container.

The container will later be used to run every python command associated with the project  
e.g
``` 
sh setup_snp.sh
```

# Running the base examples 
SNP provides DTU versions of the LLFF dataset with pretrained RAFT and SNP models on [google drive](https://drive.google.com/drive/folders/189nUV9_9YM_0bLW1Y97SQ1nK_EVpxGW6). Simply run the **examples.sh** script with the scene as parameter which will produce a video in the _SNP/saved_videos_ folder. This script will download the required data, checkpoints and pointclouds from google drive. For now I am using [gdown](https://github.com/wkentaro/gdown) to download files from google drive which has a limitation of 50 files and is problematic for all other scenes that fern. It will be changed in the future.  
e.g
```
sh examples.sh fern
```

# Creating Custom DTU dataset
To create a DTU dataset based on your own images:
- Add a $SCENE/images folder in the "custom_data" folder with your own images of the same scene from multiple views
- Run the **setup_colmap.sh** file to create the colmap container which will run the Sfm-MVS preprocessing functions
- Run the custom_dataset.sh file to create the custom dataset. Output will be located in your $SCENE folder under DTU_format.  
e.g
``` 
sh setup_colmap.sh
sh custom_dataset.sh rose
```
# Finetuning Raft
/!\ This step can take up to 2h30 depending your GPU model.  
Before training the SNP model, a Raft model needs to be finetuned in order to produce refined depth maps of the data. To do so: 
- Check that the _DTU_format_ folder of the scene is present in _custom_data/$SCENE_
- Run the **finetune.sh** script. Note that this script was not fully tested due to the lack of computing power on my computer, there might be piping errors.
- Output will be located in the folders ft_depths, ft_depths_s1, ft_depths_s2 of _custom_data/$SCENE_. Only the ft_depth folder is required for training. 
e.g
```
sh finetune.sh rose
```
Alternatively you can use [this colab notebook](https://colab.research.google.com/drive/1lMzx6pLVchVBVUfjtbEyBXd7-VIsZnNz?usp=sharing)
 to finetune the model, but requiring you to import your own DTU formated data in the notebook


# Training 
/!\ This step can also take several hours.   
To train the Pulsar model:
- Check that the _DTU_format_ folder of the scene is present in _custom_data/$SCENE_
- Run the **train.sh** script. 
- Find the output checkpoints and pointclouds in the _custom_data/$SCENE_  
``` 
sh train.sh rose 
```
Alternatively if you do not have enough GPU memory for the step 1, you can use [this colab notebook](https://colab.research.google.com/drive/16rWLr2NZZ0pjfgOTr1WN5_ZC1E4wnmBy?usp=sharing) to train the model, but requiring you to import the sculpted point cloud which you obtain after the step 0 of training.
# Inference
To run inference, make sure the models, pointclouds and render_poses_raw.npy are available in your _custom_data/$SCENE_ and run the **eval.sh** script.  
To generate an example of render_poses_raw file, you can run the new_poses.ipynb notebook
# Notes
## Image size
The docker image can be large (10Gb), to empty the docker cache use
```
docker builder prune
```
## Training and eval parameters
This version of the code doesn't allow to change the training and inference parameters. If you want ot change them you will need to:
- Make changes to the **patches/train.sh** and **patches/eval.sh** files
- Run the **update_patches.sh** script
- Change the output checkpoints and pointclouds file names in the **train.sh** and **eval.sh** root scripts.

## No GPU available
Sometimes the snp container will stop finding the CUDA GPU. This can be solved by recreating manually the container or running the **rebuild_container.sh** script.