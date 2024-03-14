SCENE=$1
DEPTH_PATH=SNP/data/LLFF/depths/$SCENE/depths
RAW_PATH=SNP/data/LLFF/raw/$SCENE
mkdir -p $DEPTH_PATH $RAW_PATH 
cp -r custom_data/$SCENE/DTU_format $RAW_PATH
#cp custom_data/$SCENE/render_poses_raw.npy $RAW_PATH
cp -a custom_data/$SCENE/ft_depths/. $DEPTH_PATH

docker exec snp sh train.sh LLFF $SCENE

CHECKPOINT_NAME="r1_dLLFF_snp_0_${SCENE}_b1_ll1_lr1e-4_lrf1e-2_lro1e-4_fo1_r1.0e-3_g1e-3_s2d1_pd0.5_dimf288_so32_bsSH_sasimple_unet_snnone_fs0.01_aff0.pth"
POINTCLOUD_NAME="r0.1_dLLFF_snp_0_${SCENE}_b1_ll1_lr1e-4_lrf1e-2_lro1e-4_fo1_r1.0e-3_g1e-3_s2d0_pd0.0_dimf27_so3_bsSH_sasimple_unet_snnone_fs0.01_aff0.pt"
cp "SNP/checkpoints/${CHECKPOINT_NAME}" "custom_data/${SCENE}"
cp "SNP/pointclouds/${POINTCLOUD_NAME}" "custom_data/${SCENE}"
