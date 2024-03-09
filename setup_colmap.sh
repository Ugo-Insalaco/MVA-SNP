# fAdapted rom https://github.com/colmap/colmap
docker pull colmap/colmap:latest
docker run -d --gpus all -w /working -v $(pwd)/SNP:/working --name colmap -it colmap/colmap:latest
