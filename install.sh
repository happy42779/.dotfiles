#!/bin/sh

# --- A simple template for the automation checking and installing steps
# --- There could be more!

# installing zsh
#PACK='zsh'
#echo "Checking if $PACK is installed."
#if ! command -v $PACK &> /dev/null
#then
#    echo "$PACK is not be found, installing..."
#	$PACKMANAGER $PACK
#elif
#	echo "$PACK is installed, proceeding..."
#fi

# --- make a list of dependencies and then check all in one chunk of code
# TODO

# Getting system release info
# giving up to extract it from /etc/os-release
# just asking

PACKMANAGER=''
PACK=''
while true; do
	read -p "Choose the package manager you use from below(1/2/3):\n
		1. apt
		2. pacman
		3. homebrew
		" choice
	case $choice in
		1) PACKMANAGER="apt install"
			break;;
		2) PACKMANAGER="pacman -S"
			break;;
		3) PACKMANAGER="brew install"
			break;;
		*) echo "invalid choice!"
	esac
done

# installing tmux
PACK='tmux'
echo "Checking if $PACK is installed."
if ! command -v $PACK &> /dev/null
then
    echo "$PACK is not be found, installing..."
	$PACKMANAGER $PACK
elif
	echo "$PACK is installed, proceeding..."
fi

echo "creating soft link... (.tmux)"
ln -s -f ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s -f ~/.dotfiles/.tmux.conf.local ~/.tmux.conf.local


# installing zsh
PACK='zsh'
echo "Checking if $PACK is installed."
if ! command -v $PACK &> /dev/null
then
    echo "$PACK is not be found, installing..."
	$PACKMANAGER $PACK
elif
	echo "$PACK is installed, proceeding..."
fi

echo "changing shell to zsh..."
chsh -s $(which zsh)

# installing ohmyzsh
# checking if curl is installed

# this can later be a for each checking an array that holds
# all the dependencies

PACK='curl'
echo "Checking if $PACK is installed."
if ! command -v $PACK &> /dev/null
then
    echo "$PACK is not be found, installing..."
	$PACKMANAGER $PACK
elif
	echo "$PACK is installed, proceeding..."


fi

echo "installing ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "creating soft link... (.zshrc)"
ln -s -f ~/.dotfiles/.zshrc ~/.zshrc


#zsh-autosuggestions
#`git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-autosuggestions`
#zsh-syntax-highlighting:
#`git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-syntax-highlighting`
#zsh-completions:   
#`git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions`

# installing ohmyzsh plugins
echo "installing separate plugins for ohmyzsh"

echo "installing zsh-autosuggestions"
[[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]] || git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-autosuggestions

echo "installing zsh-syntax-highlighting"
[[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-syntax-highlighting

echo "installing zsh-completions"
[[ -d ~/.oh-my-zsh/custom/plugins/zsh-completions ]] || git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

# effect it
source ~/.zshrc

# Use parameter to decide if .xinitrc is needed to be installed into system
# TODO


