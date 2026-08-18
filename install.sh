#!/usr/bin/env bash

set -e

echo "==> Updating system..."
sudo apt update
sudo apt upgrade -y

echo "==> Installing system dependencies..."
sudo apt install -y \
  build-essential \
  curl \
  wget \
  git \
  unzip \
  zip \
  tar \
  gzip \
  jq \
  ripgrep \
  fd-find \
  fzf \
  tree \
  tmux \
  htop \
  btop \
  ncdu \
  net-tools \
  dnsutils \
  ca-certificates \
  gnupg \
  lsb-release \
  software-properties-common \
  pkg-config \
  libssl-dev \
  libffi-dev \
  ffmpeg

# --------------------------------------------------
# Git
# --------------------------------------------------

echo "==> Git installed"
git --version

# --------------------------------------------------
# Go
# --------------------------------------------------

echo "==> Installing Go..."

GO_VERSION="$(curl -s https://go.dev/VERSION?m=text | head -n1)"

if ! command -v go >/dev/null 2>&1; then
  wget "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz

  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz

  rm /tmp/go.tar.gz
fi

# --------------------------------------------------
# Node.js
# --------------------------------------------------

echo "==> Installing Node.js..."

if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt install -y nodejs
fi

# --------------------------------------------------
# Bun
# --------------------------------------------------

echo "==> Installing Bun..."

if ! command -v bun >/dev/null 2>&1; then
  curl -fsSL https://bun.sh/install | bash
fi

# --------------------------------------------------
# Neovim
# --------------------------------------------------

echo "==> Installing Neovim..."

if ! command -v nvim >/dev/null 2>&1; then
  sudo apt install -y neovim
fi

# --------------------------------------------------
# Fish
# --------------------------------------------------

echo "==> Installing Fish..."

if ! command -v fish >/dev/null 2>&1; then
  sudo apt install -y fish
fi

# --------------------------------------------------
# Starship
# --------------------------------------------------

echo "==> Installing Starship..."

if ! command -v starship >/dev/null 2>&1; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# --------------------------------------------------
# Docker
# --------------------------------------------------

echo "==> Installing Docker..."

if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
fi

sudo systemctl enable docker
sudo systemctl start docker

if ! groups "$USER" | grep -q docker; then
  sudo usermod -aG docker "$USER"
fi

# --------------------------------------------------
# Docker Compose
# --------------------------------------------------

echo "==> Checking Docker Compose..."

docker compose version || true

# --------------------------------------------------
# PostgreSQL client
# --------------------------------------------------

echo "==> Installing PostgreSQL..."

sudo apt install -y \
  postgresql-client \
  libpq-dev

# --------------------------------------------------
# Redis
# --------------------------------------------------

echo "==> Installing Redis..."

sudo apt install -y redis-tools

# --------------------------------------------------
# Nginx
# --------------------------------------------------

echo "==> Installing Nginx..."

sudo apt install -y nginx

# --------------------------------------------------
# Certbot
# --------------------------------------------------

echo "==> Installing Certbot..."

sudo apt install -y \
  certbot \
  python3-certbot-nginx

# --------------------------------------------------
# GitHub CLI
# --------------------------------------------------

echo "==> Installing GitHub CLI..."

if ! command -v gh >/dev/null 2>&1; then
  type -p curl >/dev/null || sudo apt install curl -y

  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |
    sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" |
    sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

  sudo apt update
  sudo apt install -y gh
fi

# --------------------------------------------------
# Go development tools
# --------------------------------------------------

echo "==> Installing Go development tools..."

export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

go install mvdan.cc/gofumpt@latest
go install github.com/securego/gosec/v2/cmd/gosec@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# --------------------------------------------------
# Useful CLI tools
# --------------------------------------------------

echo "==> Installing additional CLI tools..."

sudo apt install -y \
  shellcheck \
  shfmt \
  make \
  gcc \
  g++ \
  python3 \
  python3-pip \
  python3-venv

# --------------------------------------------------
# Create common directories
# --------------------------------------------------

echo "==> Creating development directories..."

mkdir -p "$HOME/code"
mkdir -p "$HOME/projects"
mkdir -p "$HOME/.local/bin"

# --------------------------------------------------
# Final output
# --------------------------------------------------

echo
echo "========================================"
echo " Development environment installed"
echo "========================================"
echo

echo "Versions:"
echo "Go:       $(/usr/local/go/bin/go version 2>/dev/null || true)"
echo "Node:     $(node --version 2>/dev/null || true)"
echo "Bun:      $(bun --version 2>/dev/null || true)"
echo "Git:      $(git --version 2>/dev/null || true)"
echo "Neovim:   $(nvim --version 2>/dev/null | head -n1 || true)"
echo "Docker:   $(docker --version 2>/dev/null || true)"
echo "Fish:     $(fish --version 2>/dev/null || true)"
echo "Starship: $(starship --version 2>/dev/null || true)"
echo

echo "IMPORTANT:"
echo "1. Restart your terminal."
echo "2. Log out/in before using Docker without sudo."
echo "3. Configure Git with:"
echo
echo "   git config --global user.name \"Your Name\""
echo "   git config --global user.email \"you@example.com\""
echo
echo "Done."
