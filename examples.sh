# File and folder ids extracted from https://drive.google.com/drive/folders/189nUV9_9YM_0bLW1Y97SQ1nK_EVpxGW6
# If the folder has more than 50 files gdown is not available. Need to find another solution
# So for now it only works with fern that has at most 40 files per folder

SCENE=$1
DEPTH_PATH=SNP/data/LLFF/depths
RAW_PATH=SNP/data/LLFF/raw
CHECKPOINT_PATH=SNP/saved_checkpoints/LLFF
CHECKPOINT_NAME="model_best_r1_dLLFF_highres_debug_2_${SCENE}_b1_ll1_lr1e-4_lrf1e-2_lro1e-4_fo1_r1.0e-3_g1e-3_s2d0_pd0.0_dimf27_cnn0_so3_bsSH_sasimple_unet_knn0_snnone_fs0.01_aff0.pth"
POINTCLOUD_PATH=SNP/saved_pointclouds/LLFF
POINT_CLOUD_NAME="r0.1_dLLFF_highres_debug_2_${SCENE}_b1_ll1_lr1e-4_lrf1e-2_lro1e-4_fo1_r1.0e-3_g1e-3_s2d0_pd0.0_dimf27_cnn0_so3_bsSH_sasimple_unet_knn0_snnone_fs0.01_aff0.pt"

mkdir -p $DEPTH_PATH $RAW_PATH $CHECKPOINT_PATH $POINTCLOUD_PATH

if [ "$SCENE" = "fern" ]
then
    DATA_DEPTH_DRIVE_FOLDER="1PQ-kl_cVItDEpJ3CBCWR7JDlP3YdDX2E"
    DATA_RAW_DRIVE_FOLDER="131auHYPEB6dEHUV2YUiAmfQlvgMbpMfj"
    CHECKPOINT_DRIVE_FILE="1qBYTV_UAuwL_f1jexiUxiAmFjbPmVsPf"
    POINTCLOUD_DRIVE_PATH="167ilO_1WVLKx_NSSjkBP2UknX_dQjf-m"
elif [ "$SCENE" = "flower" ]
then
    DATA_DEPTH_DRIVE_FOLDER="1N5Twy66WEBrvXHguNlQJib1Rgmg2yxGV"
    DATA_RAW_DRIVE_FOLDER="1HhwR9HGgy4wFxawF1qEpc7Bto7ccSEg1"
    CHECKPOINT_DRIVE_FILE="1HkC2cHkH9uAleeaShrh2khHoWIXU-3b-"
    POINTCLOUD_DRIVE_PATH="1OosiQ71B0wZ9BG6oUkD-IfbZyMBLbt2l"
elif [ "$SCENE" = "fortress" ]
then
    DATA_DEPTH_DRIVE_FOLDER="1Eejad5N_dMV_xzvw3TH5f_Yby8E9eqUr"
    DATA_RAW_DRIVE_FOLDER="12avFG7o5M6NKKKpYo2NJXy-fd-0YxTj4"
    CHECKPOINT_DRIVE_FILE="17GYIAmmueUk8XVbnF2MAb2e04z1WdCl-"
    POINTCLOUD_DRIVE_PATH="1l8qV6ysFAdE8Vck77XBxjb6OABRIi8JS"
elif [ "$SCENE" = "horns" ]
then
    DATA_DEPTH_DRIVE_FOLDER="1P00XMJGvONgmMLQESKlBGjwDRAh_Pf25"
    DATA_RAW_DRIVE_FOLDER="1HUt_NpULFfD3tbhvdVzhO2xeOKhDVPpH"
    CHECKPOINT_DRIVE_FILE="1RFkcjb7tlX9_dzwOt9JcIcwsXMmVU7PD"
    POINTCLOUD_DRIVE_PATH="1BYsGvxRiYKiQ9DShY8bgPGlkOZ68nr3Z"
elif [ "$SCENE" = "leaves" ]
then
    DATA_DEPTH_DRIVE_FOLDER="1hW8qQViVMghGKQGxvFIiHN3M6FVqDMIo"
    DATA_RAW_DRIVE_FOLDER="1-E5wnO734E97u0Jo-esC5LcZSfflZvIP"
    CHECKPOINT_DRIVE_FILE="1N9LdP9JGmYj9Hfih8ktOaSQgKxmyvfSM"
    POINTCLOUD_DRIVE_PATH="17jQ_cm_WjJnXUO5Lz7ZNLhc3m37Vqeyd"
elif [ "$SCENE" = "orchids" ]
then
    DATA_DEPTH_DRIVE_FOLDER="1O8KNfUq0M5MrHOGUXi5NRGND8oejI-4G"
    DATA_RAW_DRIVE_FOLDER="1QeiNLRU0xlqBqMwRkNDgfw1BgyEieR1V"
    CHECKPOINT_DRIVE_FILE="1pYWZ-7tM8lYW60eayQrr8ScyPkN-XecQ"
    POINTCLOUD_DRIVE_PATH="143dnwSDwt4Udva0x5dRmCYWl_58z67a5"
elif [ "$SCENE" = "room" ]
then
    DATA_DEPTH_DRIVE_FOLDER="1Ot0Ixi2PnxeKDQfb1p8TMQDdSbuLA5im"
    DATA_RAW_DRIVE_FOLDER="1ctdsaGPnWBfkvOVWKGRNQAzKtmEu2yN-"
    CHECKPOINT_DRIVE_FILE="19wPuHVhJUJPaVDo-UEdSRSyjLRd9zT4Z"
    POINTCLOUD_DRIVE_PATH="1qLjYz-7sQAj1ShGFqyROCGJ6UZ27-Uoi"
elif [ "$SCENE" = "trex" ]
then
    DATA_DEPTH_DRIVE_FOLDER="1apyveJODFFt4jrM2_jlq2zSdPnnI658o"
    DATA_RAW_DRIVE_FOLDER="1pjMj5UQt_2cbMFcOafZrvEAvifE2SdSF"
    CHECKPOINT_DRIVE_FILE="1hwmdO7GM5wZjDlNOJGgRXl4hOJqMLw1u"
    POINTCLOUD_DRIVE_PATH="1xQc0ExojGBQm98_Lc_6MBA5CaPk6urPL"
else
    echo Unsupported scene $SCENE
    exit 1
fi 

DATA_DEPTH_DRIVE_FOLDER="https://drive.google.com/drive/folders/${DATA_DEPTH_DRIVE_FOLDER}"
DATA_RAW_DRIVE_FOLDER="https://drive.google.com/drive/folders/${DATA_RAW_DRIVE_FOLDER}"

if [ ! -d "${DEPTH_PATH}/${SCENE}" ]
then 
    gdown --folder $DATA_DEPTH_DRIVE_FOLDER
    mv $SCENE $DEPTH_PATH
fi
if [ ! -d "${RAW_PATH}/${SCENE}" ]
then
    gdown --folder $DATA_RAW_DRIVE_FOLDER
    mv $SCENE $RAW_PATH
fi

if [ ! -f "${CHECKPOINT_PATH}/${CHECKPOINT_NAME}" ]
then
    python3 -m gdown $CHECKPOINT_DRIVE_FILE
    mv $CHECKPOINT_NAME $CHECKPOINT_PATH
fi

if [ ! -f "${POINTCLOUD_PATH}/${POINT_CLOUD_NAME}" ]
then
    python3 -m gdown $POINTCLOUD_DRIVE_PATH
    mv $POINT_CLOUD_NAME $POINTCLOUD_PATH
fi
docker exec snp sh eval.sh LLFF $SCENE
docker exec snp chmod -R 777 /working/saved_videos