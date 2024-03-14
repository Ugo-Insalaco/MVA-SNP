docker container stop snp colmap
docker container rm snp colmap
docker run -d --gpus all -w /working -v $(pwd)/SNP:/working --name colmap -it colmap/colmap:latest
docker run -t -d --name snp -v $(pwd)/SNP:/working --gpus all -it snp
