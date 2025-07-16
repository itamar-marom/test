#!/bin/bash

if ! command -v aws >/dev/null 2>&1; then
  brew install awscli
else
  echo "awscli is already installed."
fi

if ! command -v saml2aws >/dev/null 2>&1; then
  brew install saml2aws
else
  echo "saml2aws is already installed."
fi




read -p "Enter your full name: " name
export NAME="$name"

read -p "Enter your Onyx email: " email
export SAML2AWS_USERNAME="$email"

cp ./saml2aws.template ~/.saml2aws

# Verify 
saml2aws login -a development-admin
echo "Verified!"




# Install Utils

if ! command -v git >/dev/null 2>&1; then
  brew install git
else
  echo "git is already installed."
fi

# Configure git user.name if not already set
if ! git config --global user.name >/dev/null; then
  git config --global user.name "$NAME"
else
  echo "git user.name is already configured."
fi

# Configure git user.email if not already set
if ! git config --global user.email >/dev/null; then
  git config --global user.email "$SAML2AWS_USERNAME"
else
  echo "git user.email is already configured."
fi


# Install tailsacle
if ! command -v tailscale >/dev/null 2>&1; then
  echo "Tailscale is not installed."
  echo "Please visit the following link to download Tailscale for Mac:"
  echo "https://tailscale.com/download/mac"
  echo ""
  echo "Download Tailscale and follow the installation instructions on the website."
  echo ""
  read -p "Press Enter once you have finished installing Tailscale to continue..."
else
  echo "Tailscale is already installed."
fi


if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed."
  echo "Please visit the following link to download Docker Desktop for Mac:"
  echo "https://www.docker.com/products/docker-desktop/"
  echo ""
  echo "Download Docker Desktop and follow the installation instructions on the website."
  echo ""
  read -p "Press Enter once you have finished installing Docker Desktop to continue..."
else
  echo "Docker is already installed."
fi


if ! command -v earthly >/dev/null 2>&1; then
  echo "Installing earthly..."
  brew install earthly && earthly bootstrap
else
  echo "earthly is already installed."
fi


echo "Now go to Github and setup single sign on to be part of the Onyx organization."
read -p "Press Enter once you have finished"


echo "Checking for existing SSH keys..."
if [ ! -f ~/.ssh/id_ed25519 ]; then
  echo "No SSH key found. Generating a new ed25519 SSH key..."
  ssh-keygen -t ed25519 -C "$SAML2AWS_USERNAME" -f ~/.ssh/id_ed25519 -N ""
else
  echo "An SSH key already exists at ~/.ssh/id_ed25519"
fi

echo ""
echo "Your public SSH key is:"
echo ""
cat ~/.ssh/id_ed25519.pub
echo ""
echo "Copy the above SSH public key."

echo "Visit https://github.com/settings/keys to add your SSH key to your GitHub account."
read -p "Press Enter once you have added your SSH key to GitHub to continue..."
