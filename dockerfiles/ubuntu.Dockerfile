FROM ubuntu:20.04

# Base
LABEL org.opencontainers.image.source https://github.com/ppeetteerrs/docker-components
LABEL org.opencontainers.image.description "Ubuntu + Oh-My-ZSH + Starship + CLI Aliases + Non-root User (UID 1000)"

## Settings
WORKDIR /root
SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

## Update
RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install -y sudo nano git wget curl htop build-essential cmake

## Copy
COPY resources /resources
RUN chmod -R 777 /resources

# Add User
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME && \
	useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
	echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
	chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

# Shell
## ZSH
RUN sudo apt-get install -y zsh && \
	sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
	echo "export HISTSIZE=1000000" >> ~/.zshrc && \
	echo "export SAVEHIST=1000000" >> ~/.zshrc && \
	echo "setopt EXTENDED_HISTORY" >> ~/.zshrc && \
	sed -i 's/plugins=(git)/plugins=(zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc

## Starship
RUN /resources/starship.sh

## Aliases
RUN cp /resources/aliases.bashrc ~/.aliases
RUN echo "source ~/.aliases" >> ~/.bashrc
RUN if [ -x "$(command -v zsh)" ]; then echo "source ~/.aliases" >> ~/.zshrc; fi

CMD "zsh"