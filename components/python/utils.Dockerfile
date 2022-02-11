# Linters and Formatters
RUN mamba install -y autopep8 black yapf pycodestyle flake8 autoflake isort

# Utils
RUN mamba install -y tqdm jupyter notebook rich numpy scipy matplotlib pandas seaborn