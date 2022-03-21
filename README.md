# Docker Components
Snippets, resources and Dockerfiles for building my personal Docker Images.

# Folder Structure
```txt
📦docker-components
 ┣ 📂dockerfiles              --- Dockerfiles to build images
 ┃ ┣ 📜fyp.Dockerfile
 ┃ ┣ 📜opencv.Dockerfile
 ┃ ┣ 📜python.Dockerfile
 ┃ ┣ 📜pytorch.Dockerfile
 ┃ ┣ 📜rust.Dockerfile
 ┃ ┗ 📜ubuntu.Dockerfile
 ┣ 📂resources                --- Resource files to copy into images
 ┃ ┣ 📜aliases.bashrc         --- CLI aliases
 ┃ ┣ 📜starship.sh            --- Install Starship
 ┃ ┗ 📜starship.toml          --- Starship config
 ┣ 📂snippets                 --- Dockerfile snippets to achieve different functions
 ┃ ┣ 📂python
 ┃ ┃ ┣ 📜mamba.Dockerfile
 ┃ ┃ ┗ 📜packages.Dockerfile
 ┃ ┣ 📂rust
 ┃ ┃ ┗ 📜rust.Dockerfile
 ┃ ┣ 📜add_user.Dockerfile
 ┃ ┣ 📜base.Dockerfile
 ┃ ┗ 📜shell.Dockerfile
 ┣ 📜.gitignore
 ┣ 📜README.md
 ┗ 📜build.sh                 --- List of commands to build images & push to ghcr.io 
```