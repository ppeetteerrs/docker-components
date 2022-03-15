FROM ppeetteerrs/ubuntu:20.04

# Mamba
# Install mamba
RUN wget -q "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh" && \
	bash "Mambaforge-$(uname)-$(uname -m).sh" -b && \
	rm "Mambaforge-$(uname)-$(uname -m).sh"

## Create user Python environment (copy from existing base if it exists)
RUN if [ ! -z $(which conda) ]; \
	then conda create -p ~/mambaforge/envs/user --clone base -y; \
	else ~/mambaforge/bin/mamba create -n user python=3.9 -y; \
	fi

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
	mamba install -y black flake8 isort tqdm jupyter notebook rich numpy=1.21.5 scipy matplotlib pandas seaborn && \
	pip install ipympl

CMD "zsh"