SCENE=$1

if [ -z "$SCENE" ]
then
    echo "Missing scene argument"
    exit 1
fi

DEPTH_PATH=SNP/data/LLFF/depths
RAW_PATH=SNP/data/LLFF/raw
CHECKPOINT_PATH=SNP/saved_checkpoints/LLFF
CHECKPOINT_NAME="model_best_r1_dLLFF_snp_0_${SCENE}_b1_ll1_lr1e-4_lrf1e-2_lro1e-4_fo1_r1.0e-3_g1e-3_s2d1_pd0.5_dimf288_so32_bsSH_sasimple_unet_snnone_fs0.01_aff0.pth"
# CHECKPOINT_NAME="r1_dLLFF_snp_0_${SCENE}_b1_ll1_lr1e-4_lrf1e-2_lro1e-4_fo1_r1.0e-3_g1e-3_s2d1_pd0.5_dimf288_so32_bsSH_sasimple_unet_snnone_fs0.01_aff0.pth"
POINTCLOUD_PATH=SNP/saved_pointclouds/LLFF
POINTCLOUD_NAME="r0.1_dLLFF_snp_0_${SCENE}_b1_ll1_lr1e-4_lrf1e-2_lro1e-4_fo1_r1.0e-3_g1e-3_s2d0_pd0.0_dimf27_so3_bsSH_sasimple_unet_snnone_fs0.01_aff0.pt"

cp "custom_data/${SCENE}/${CHECKPOINT_NAME}" $CHECKPOINT_PATH
cp "custom_data/${SCENE}/${POINTCLOUD_NAME}" $POINTCLOUD_PATH

DEPTH_PATH=SNP/data/LLFF/depths/$SCENE/depths
RAW_PATH=SNP/data/LLFF/raw/$SCENE

mkdir -p $DEPTH_PATH $RAW_PATH 
cp -r custom_data/$SCENE/DTU_format $RAW_PATH
cp custom_data/$SCENE/render_poses_raw.npy $RAW_PATH
cp -a custom_data/$SCENE/ft_depths/. $DEPTH_PATH

docker exec snp sh eval.sh LLFF $SCENE saved_pointclouds/LLFF/${POINTCLOUD_NAME} saved_checkpoints/LLFF/${CHECKPOINT_NAME}

cp "SNP/saved_videos/r1_dLLFF_snp_eval_0_${SCENE}_b1_ll1_lr1e-4_lrf1e-2_lro1e-4_fo1_r1.0e-3_g1e-3_s2d1_pd0.5_dimf288_so32_bsSH_sasimple_unet_snnone_fs0.01_aff0.gif" custom_data/$SCENE
