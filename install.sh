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
#else
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
	echo -e "What package manager do you use ? \n1. apt \n2. pacman \n3. homebrew"
	read -p "Type your choice [1/2/3]: " choice
	case $choice in
		1) PACKMANAGER="apt install"
			break;;
		2) PACKMANAGER="pacman -S"
			break;;
		3) PACKMANAGER="brew install"
			break;;
		0) exit
			break;;
		*) echo "invalid choice!"
	esac
done

# installing tmux
PACK='tmux'
echo ":: Checking if $PACK is installed."
if ! command -v $PACK &> /dev/null
then
    echo ":: $PACK is not be found, installing..."
	$PACKMANAGER $PACK
else
	echo ":: $PACK is installed, proceeding..."
fi

echo ":: Creating soft link... (.tmux)"
ln -s -f ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s -f ~/.dotfiles/.tmux.conf.local ~/.tmux.conf.local


# installing zsh
PACK='zsh'
echo ":: Checking if $PACK is installed."
if ! command -v $PACK &> /dev/null
then
    echo ":: $PACK is not be found, installing..."
	$PACKMANAGER $PACK
else
	echo ":: $PACK is installed, proceeding..."
fi

echo ":: Changing shell to zsh..."
chsh -s $(which zsh)

# installing ohmyzsh
# checking if curl is installed

# this can later be a for each checking an array that holds
# all the dependencies

PACK='curl'
echo ":: Checking if $PACK is installed."
if ! command -v $PACK &> /dev/null
then
    echo ":: $PACK is not be found, installing..."
	$PACKMANAGER $PACK
else
	echo ":: $PACK is installed, proceeding..."


fi

echo ":: Installing ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo ":: Creating soft link... (.zshrc)"
ln -s -f ~/.dotfiles/.zshrc ~/.zshrc


#zsh-autosuggestions
#`git clone https://github.com/zsh-users/zsh-autosuggestions ${zsh_custom:-${zsh:-~/.oh-my-zsh}/custom}/plugins/zsh-autosuggestions`
#zsh-syntax-highlighting:
#`git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-syntax-highlighting`
#zsh-completions:   
#`git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions`

# installing ohmyzsh plugins
echo ":: Installing separate plugins for ohmyzsh"

echo ":: Installing zsh-autosuggestions"
[[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]] || (echo "Installed, skip." && git clone https://github.com/zsh-users/zsh-autosuggestions ${zsh_custom:-${zsh:-~/.oh-my-zsh}/custom}/plugins/zsh-autosuggestions)

echo ":: Installing zsh-syntax-highlighting"
[[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]] || (echo "Installed, skip." && git clone https://github.com/zsh-users/zsh-syntax-highlighting ${zsh_custom:-${zsh:-~/.oh-my-zsh}/custom}/plugins/zsh-syntax-highlighting)

echo ":: Installing zsh-completions"
[[ -d ~/.oh-my-zsh/custom/plugins/zsh-completions ]] || (echo "Installed, skip." && git clone https://github.com/zsh-users/zsh-completions ${zsh_custom:-${zsh:-~/.oh-my-zsh}/custom}/plugins/zsh-completions)


# use parameter to decide if .xinitrc is needed to be installed into system
# todo
[[ $1 == "--dwm" ]] && (echo ":: Installing .xinitrc." && ln -s -f ~/.dotfiles/.xinitrc ~/.xinitrc)


# 
# effect it
#source ~/.zshrc
exec zsh -l
