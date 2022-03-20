FROM nvidia/cuda:11.2.0-devel-ubuntu20.04

IMPORT basics
IMPORT add_user
IMPORT shell/zsh
IMPORT shell/starship
IMPORT shell/alias
IMPORT python/mamba
IMPORT python/common
IMPORT python/pytorch
IMPORT python/opencv

# Training
RUN mamba install -y python-dotenv python-lmdb
RUN pip install -U stylegan2_torch lpips torchgeometry

# Data Parsing
RUN pip install deepdrr==1.1.0a4
RUN mamba install -y pycuda python-dotenv python-lmdb
RUN mamba install -y -c simpleitk simpleitk
RUN mamba install -y -c rapidsai -c nvidia cusignal

CMD "zsh"