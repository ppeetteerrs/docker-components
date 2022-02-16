FROM nvidia/cuda:11.6.0-devel-ubuntu20.04

IMPORT basics
IMPORT add_user
IMPORT shell/zsh
IMPORT shell/starship
IMPORT shell/alias
IMPORT python/mamba
IMPORT python/common
IMPORT python/opencv
IMPORT python/pytorch

RUN mamba install -y python-dotenv python-lmdb
RUN pip install -U stylegan2_torch lpips torchgeometry
RUN mamba clean --all

CMD "zsh"