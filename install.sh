#!/bin/bash

# Tools
sudo apt update
sudo apt install -y vim wget curl make xclip htop jq resolvconf htop autojump fzf build-essential zsh shellcheck vlc bat

# Go
if test ! -d /usr/local/go; then
  printf "Installing Go\n"
  curl -O https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz
  tar xvf go1*.tar.gz
  sudo chown -R root:root ./go
  sudo mv go /usr/local
fi

# Oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  printf "Installing ohmyzsh\n"
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

# Fuzzy search
if test ! -f /bin/fzf; then
  printf "Installing fzf\n"
  git clone https://github.com/junegunn/fzf.git /tmp/fzf
  /tmp/fzf/install
fi

# Docker
if test ! -f /usr/bin/docker; then
  printf "Installing Docker\n"
  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-ce docker-compose
  sudo groupadd docker
  sudo usermod -aG docker "${USER}"
  newgrp docker
fi

# Spotify
if ! find /etc/apt/ -name "*.list" | xargs cat | grep "spotify"; then
  printf "Installing Spotify\n"
  curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
  sudo apt update
  sudo apt install -y spotify-client
fi

# Telegram
if ! find /etc/apt/ -name "*.list" | xargs cat | grep "telegram"; then
  printf "Installing Telegram\n"
  sudo add-apt-repository -y ppa:atareao/telegram
  sudo apt update
  sudo apt install -y telegram
fi

# Slack
if ! dpkg -s slack-desktop; then
  printf "Installing Slack\n"
  wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.4.2-amd64.deb
  sudo apt install -y ./slack-desktop-*.deb
  rm slack-desktop-*.deb
fi

# Go libraries
GO111MODULE="on" go get sigs.k8s.io/kind@v0.7.0
GO111MODULE="on" go get github.com/giantswarm/luigi
GO111MODULE="on" go get github.com/giantswarm/architect
GO111MODULE="on" go get github.com/giantswarm/gsctl
GO111MODULE="on" go get github.com/giantswarm/devctl

# IntelliJ
if ! ls /opt/idea-* 1> /dev/null 2>&1; then
  printf "Installing IntelliJ\n"
  curl -O https://download.jetbrains.com/idea/ideaIU-2020.1.tar.gz
  sudo tar -xzf ideaIU.tar.gz -C /opt
  rm ideaIU*.tar.gz
fi

# SDKMan
if test ! -f /home/jose/.sdkman/src/sdkman-main.sh; then
  curl -s "https://get.sdkman.io" | bash
fi