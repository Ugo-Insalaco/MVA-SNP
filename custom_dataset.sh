SCENE=$1
if [ -z "$SCENE" ]
then
    echo 'invalid scene name'
    exit 1
fi
SCENE_PATH="custom_data/${SCENE}"
if [ ! -d $SCENE_PATH ]
then 
    echo "no folder associated to scene ${SCENE}"
    exit 2
fi
IMAGES_PATH="${SCENE_PATH}/images"
if [ ! -d $IMAGES_PATH ]
then 
    echo "missing image folder for scene ${SCENE}"
    exit 3
fi

# Move images
RAW_IMAGE_PATH="SNP/mvs/raw_images"
mkdir -p "${RAW_IMAGE_PATH}/${SCENE}"
cp -r "${IMAGES_PATH}" "${RAW_IMAGE_PATH}/${SCENE}/images"

MVS_DIR=/working/mvs
INPUT_DIR="${MVS_DIR}/raw_images_resized"
RESIZED_IMAGE_PATH="SNP/mvs/raw_images_resized/${SCENE}"
mkdir -p "${RESIZED_IMAGE_PATH}/sparse" "${RESIZED_IMAGE_PATH}/dense"

# Resize Images
H=1200
W=1600
echo "=== 1/8 Resizing images ==="
docker exec -w $MVS_DIR snp python3 img_move_and_reisze.py --s ./raw_images/ --t ./raw_images_resized/ --h $H --w $W

# Colmap processing with colmap container
echo "=== 2/8 Feature extraction ==="
docker exec -w $MVS_DIR colmap colmap feature_extractor --database_path $INPUT_DIR/$SCENE/db.db --image_path $INPUT_DIR/$SCENE/images --ImageReader.single_camera 1 --ImageReader.camera_model SIMPLE_PINHOLE
echo "=== 3/8 Exhaustive matching ==="
docker exec -w $MVS_DIR colmap colmap exhaustive_matcher --database_path $INPUT_DIR/$SCENE/db.db  --SiftMatching.guided_matching 1
echo "=== 4/8 Mapping ==="
docker exec -w $MVS_DIR colmap colmap mapper --database_path $INPUT_DIR/$SCENE/db.db --image_path $INPUT_DIR/$SCENE/images --output_path $INPUT_DIR/$SCENE/sparse --Mapper.init_min_tri_angle 4 --Mapper.num_threads 16 --Mapper.multiple_models 0 --Mapper.extract_colors 0
echo "=== 5/8 Image undistortion ==="
docker exec -w $MVS_DIR colmap colmap image_undistorter --image_path $INPUT_DIR/$SCENE/images --input_path $INPUT_DIR/$SCENE/sparse/0 --output_path $INPUT_DIR/$SCENE/dense --output_type COLMAP
echo "=== 6/8 Patch Match Stereo ==="
docker exec -w $MVS_DIR colmap colmap patch_match_stereo --workspace_path $INPUT_DIR/$SCENE/dense --workspace_format COLMAP --PatchMatchStereo.max_image_size $W
echo "=== 7/8 Stereo Fusion ==="
docker exec -w $MVS_DIR colmap colmap stereo_fusion --workspace_path $INPUT_DIR/$SCENE/dense --workspace_format COLMAP --input_type geometric --output_path $INPUT_DIR/$SCENE/dense/fused.ply --StereoFusion.min_num_pixels 2 --StereoFusion.max_image_size $W
docker exec -w $MVS_DIR colmap chmod -R 777 $INPUT_DIR

# Convert to DTU Format with snp container
echo "=== 8/8 Convert to DTU format ==="
docker exec -w $MVS_DIR snp python3 colmap2dtu.py --scene $SCENE --colmap_output_dir $INPUT_DIR
docker exec -w $MVS_DIR snp chmod -R 777 "/app/mvs/raw_images_resized/${SCENE}/DTU_format"

cp -r "${RESIZED_IMAGE_PATH}/DTU_format" $SCENE_PATH