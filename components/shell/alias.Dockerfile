RUN cp /resources/aliases.bashrc ~/.aliases

RUN echo "source ~/.aliases" >> ~/.bashrc
RUN if [ -x "$(command -v zsh)" ]; then echo "source ~/.aliases" >> ~/.zshrc; fi