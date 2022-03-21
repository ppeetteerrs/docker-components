FROM ghcr.io/ppeetteerrs/ubuntu:20.04

ARG PYTHON_VERSION=3.9

LABEL org.opencontainers.image.source https://github.com/ppeetteerrs/docker-components
LABEL org.opencontainers.image.description "Ubuntu 20.04 + Mambaforge Non-root Environment (user) + Common Python Utility Libraries"

# Mamba
# Install mamba
RUN wget -q "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh" && \
	bash "Mambaforge-$(uname)-$(uname -m).sh" -b && \
	rm "Mambaforge-$(uname)-$(uname -m).sh" && \
	~/mambaforge/bin/mamba create -n user python=$PYTHON_VERSION -y

## Automatically activate user environment, disable logo and disable conda prompt for starship
ENV PATH=/home/user/mambaforge/bin:$PATH
RUN mamba init --all && \
	conda env config vars set MAMBA_NO_BANNER=1 && \
	conda config --set changeps1 False && \
	echo "conda activate user" >> ~/.bashrc && \
	echo "conda activate user" >> ~/.zshrc

## Change shell
SHELL ["conda", "run", "-n", "user", "/bin/bash", "-c"]

# Linters and Formatters
RUN mamba install -n base -y autoflake && \
	mamba install -y black flake8 isort

CMD "zsh"