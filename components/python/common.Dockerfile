# Linters and Formatters
RUN mamba install -y black flake8 isort autoflake

# Utils
RUN mamba install -y tqdm jupyter notebook rich numpy scipy matplotlib pandas seaborn
RUN pip install ipympl