SCENE=$1
CHECKPOINT_PATH=SNP/mvs/checkpoints/DTU_trained.pth
SCENE_PATH="SNP/mvs/raw_images_resized/${SCENE}/DTU_format"
MVS_DIR=/working/mvs
OUTPUT_DIR="SNP/mvs/mvs_depths/ft_depths/${SCENE}"

# Downloading checkpoint if required
if [ ! -f $CHECKPOINT_PATH ]
then
    echo "Downloading checkpoint"
    python3 -m gdown 1S8DxWBDR0EDHgyis4JC2z7B1NFdPLccv 
    mkdir -p SNP/mvs/checkpoints
    mv DTU_trained.pth SNP/mvs/checkpoints/
fi

# Copying Scene data if not present from the custom folder
if [ ! -d $SCENE_PATH ]
then
    echo "Copying DTU format to mvs folder"
    cp -r "custom_data/${SCENE}/DTU_format" SNP/mvs/raw_images_resized/${SCENE}
fi

# Runing finetune
echo "Finetuning scene $SCENE"
docker exec -w $MVS_DIR snp sh depth_ft_inf.sh $SCENE
docker exec -w $MVS_DIR snp chmod -R 777 ${MVS_DIR}/mvs_depths

# Saving output
cp -a "${OUTPUT_DIR}/depths/." "custom_data/${SCENE}/ft_depths"
cp -a "SNP/mvs/mvs_depths/ft_depths_s1/${SCENE}/depths/." "custom_data/${SCENE}/ft_depths_s1"
cp -a "SNP/mvs/mvs_depths/ft_depths_s2/${SCENE}/depths/." "custom_data/${SCENE}/ft_depths_s2"
cp "SNP/mvs/checkpoints/${SCENE}_ft_depth_gradual_new_colmap.pth" "custom_data/${SCENE}"