#!/usr/bin/env bash

wget -q https://starship.rs/install.sh
chmod +x ./install.sh

# WHY IS STARSHIP INSTALL SCRIPT SO STUPID??
if [ -x "$(command -v dash)" ]; then
	dash ./install.sh --yes
else
	sh ./install.sh --yes
fi
rm ./install.sh

echo 'eval "$(starship init bash)"' >> ~/.bashrc

if [ -x "$(command -v zsh)" ]; then
	echo "zsh intalled"
	echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

mkdir -p ~/.config
cp /resources/starship.toml ~/.config/