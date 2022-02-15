RUN sudo apt-get install -y zsh && \
	sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
	echo "export HISTSIZE=1000000" >> ~/.zshrc && \
	echo "export SAVEHIST=1000000" >> ~/.zshrc && \
	echo "setopt EXTENDED_HISTORY" >> ~/.zshrc && \
	sed -i 's/plugins=(git)/plugins=(zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc