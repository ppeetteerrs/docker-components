FROM nvcr.io/nvidia/pytorch:21.12-py3

IMPORT basics
IMPORT add_user
IMPORT zsh
IMPORT starship
IMPORT python/mamba
IMPORT python/utils

CMD "bash"