FROM ubuntu:20.04

IMPORT basics
IMPORT add_user
IMPORT shell/zsh
IMPORT shell/starship
IMPORT shell/alias
IMPORT python/mamba
IMPORT python/common

RUN mamba install -y opencv pillow
RUN mamba install -y simpleitk -c simpleitk

CMD "zsh"