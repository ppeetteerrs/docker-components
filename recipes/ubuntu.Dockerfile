FROM ubuntu:20.04

IMPORT basics
IMPORT add_user
IMPORT shell/zsh
IMPORT shell/starship
IMPORT shell/alias

CMD "zsh"