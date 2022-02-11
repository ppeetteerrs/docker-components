FROM nvcr.io/nvidia/pytorch:21.12-py3

IMPORT basics
IMPORT add_user
IMPORT shell/zsh
IMPORT shell/starship
IMPORT shell/alias
IMPORT python/mamba
IMPORT python/common

RUN mamba install -y tensorboard pytorch-lightning python-lmdb
RUN pip install -U torch-tb-profiler

CMD "zsh"