FROM ubuntu:20.04

IMPORT basics
IMPORT add_user
IMPORT shell/zsh
IMPORT shell/starship
IMPORT shell/alias
IMPORT python/mamba
IMPORT python/common

RUN mamba install -y pytorch torchvision cudatoolkit=11.3 -c pytorch
RUN mamba install -y cudatoolkit-dev=11.3
RUN mamba install -y tensorboard pytorch-lightning python-lmdb
RUN pip install -U torch-tb-profiler
RUN mamba clean --all

CMD "zsh"