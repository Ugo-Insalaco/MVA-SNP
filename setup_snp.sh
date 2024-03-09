# Install local dependancies
pip install gdown

# Clone SNP
git clone https://github.com/princeton-vl/SNP.git

# Patch
cp patches/eval.sh SNP/eval.sh
cp patches/train.sh SNP/train.sh
cp patches/colmap2dtu.py SNP/mvs/colmap2dtu.py
cp patches/ply.py SNP/mvs/ply.py
cp patches/depth_ft_inf.sh SNP/mvs/depth_ft_inf.sh

# Build Docker image
docker build -t snp . -f Dockerfile

# Start Docker container
docker run -t -d --name snp -v $(pwd)/SNP:/working --gpus all -it snp
