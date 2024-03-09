scan=$1
name=${scan}_ft_depth_gradual_new_colmap
crop_h=600
crop_w=800

echo $name

python3 finetune.py --name $name --setting LLFF --batch_size 1 \
--DD 128 --num_f 5  --SUM_FREQ 1 --restore_ckpt ./checkpoints/DTU_trained.pth --num_steps 5000 --single_scan $scan \
--crop_h $crop_h --crop_w $crop_w --data_augmentation 0 --lr 0.000025 --loss_type depth_gradual --disp_runup 1000

basedir="./mvs_depths"
mkdir -p basedir

ckpt_name="./checkpoints/${name}.pth"

python3 inference.py \
--output_folder "${basedir}/ft_depths_s1" --setting LLFF --DD 128 --num_f 5 --scale 1 \
--single_scan $scan \
--ckpt $ckpt_name

python3 inference.py \
--output_folder "${basedir}/ft_depths_s2" --setting LLFF --DD 128 --num_f 5 --scale 2 \
--single_scan $scan \
--ckpt $ckpt_name

python combine.py --scan ${scan} --folder "${basedir}/ft_depths" --folder1 "${basedir}/ft_depths_s1" --folder2 "${basedir}/ft_depths_s2"