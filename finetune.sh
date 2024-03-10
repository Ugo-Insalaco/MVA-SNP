SCENE=$1
CHECKPOINT_PATH=SNP/mvs/checkpoints/DTU_trained.pth
SCENE_PATH="SNP/mvs/raw_images_resized/${SCENE}/DTU_format"
MVS_DIR=/working/mvs
OUTPUT_DIR=SNP/mvs/mvs_depths/ft_depths/$SCENE
if [ ! -f $CHECKPOINT_PATH ]
then
    echo "Downloading checkpoint"
    python3 -m gdown 1S8DxWBDR0EDHgyis4JC2z7B1NFdPLccv 
    mkdir -p SNP/mvs/checkpoints
    mv DTU_trained.pth SNP/mvs/checkpoints/
fi

if [ ! -d $SCENE_PATH ]
then
    echo "Copying DTU format to mvs folder"
    cp -r "custom_data/${SCENE}/DTU_format" SNP/mvs/raw_images_resized/${SCENE}
fi
echo "Finetuning scene $SCENE"
docker exec -w $MVS_DIR snp sh depth_ft_inf.sh $SCENE
docker exec -w $MVS_DIR snp chmod -R 777 $OUTPUT_DIR

cp -r $OUTPUT_DIR custom_data/${SCENE}
