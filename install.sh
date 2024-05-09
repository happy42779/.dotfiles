#!/bin/bash
#############################################################################
# In order to make it compatible with different platforms, here the SHEBANG #
# is going to be changed into /bin/dash which is the default program for	#
# Debian.																	#
# !!!!!!!!!!!!!!!!!!SHOULD AVOID BASHISM FEATURES!!!!!!!!!!!!!!!!!!!!!!!!!!	#
#############################################################################

# --- A simple template for the automation checking and installing steps
# --- There could be more!

PACKMANAGER=''
UNKNOWN_PACKMGR=''
PACKS="curl git zsh tmux gpg pass wget"

if [[ "$(uname)" == "Darwin" ]]; then
	PACKMANAGER="sudo brew install"
elif [[ "$(cat /etc/os-release | grep -E '^NAME=')" == *Debian* ]]; then
	PACKMANAGER="sudo apt install"
elif [[ "$(cat /etc/os-release | grep -E '^NAME=')" == *Arch* ]]; then
	PACKMANAGER="sudo pacman -S"
else
	echo "Unknown distro! Please specify a package manager, and the action to install:"
	echo "Eg: apt install"
	read UNKNOWN_PACKMGR

	PACKMANAGER="sudo $(UNKNOWN_PACKMGR)"
fi

echo ":: Checking dependencies..."
for PACK in $PACKS; do
	echo ":: Checking if $PACK is installed ..."
	if ! command -v $PACK 1>/dev/null; then
		echo "$PACK is not installed, installing... "
		$PACKMANAGER $PACK
	else
		echo "$PACK is already installed, skipping..."
	fi
done

# changing shell to zsh, if current shell is not zsh
echo ":: Changing shell to zsh..."

shell=$(echo $SHELL)
# [ ${shell##*/} = "zsh" ] && echo "zsh is already the default shell, skipping" || (chsh -s $(which zsh) && echo ":: DONE")
[ ${shell##*/} = "zsh" ] && echo "zsh is already the default shell, skipping" || (echo ":: DONE")

# checking if .oh-my-zsh exists
echo ":: Installing .ohmyzsh"
[ -d "$HOME/.oh-my-zsh" ] && echo ".oh-my-zsh folder exists, assuming it's installed correctly" || (echo ":: Installing ohmyzsh" && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && echo ":: DONE")

echo ":: Creating soft link... (.zshrc)"
ln -s -f $HOME/.dotfiles/.zshrc $HOME/.zshrc
echo ":: DONE"

# installing ohmyzsh plugins
echo ":: Installing separate plugins for ohmyzsh"

echo "Installing zsh-autosuggestions"
[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] && echo "Installed, skip." || (git clone https://github.com/zsh-users/zsh-autosuggestions ${zsh_custom:-${zsh:-$HOME/.oh-my-zsh}/custom}/plugins/zsh-autosuggestions && echo ":: DONE")

echo "Installing zsh-syntax-highlighting"
[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] && echo "Installed, skip." || (git clone https://github.com/zsh-users/zsh-syntax-highlighting ${zsh_custom:-${zsh:-$HOME/.oh-my-zsh}/custom}/plugins/zsh-syntax-highlighting && echo ":: DONE")

echo "Installing zsh-completions"
[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ] && echo "Installed, skip." || (git clone https://github.com/zsh-users/zsh-completions ${zsh_custom:-${zsh:-$HOME/.oh-my-zsh}/custom}/plugins/zsh-completions && echo ":: DONE")

echo ":: Creating soft link... (.tmux)"
ln -s -f $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf
ln -s -f $HOME/.dotfiles/.tmux.conf.local $HOME/.tmux.conf.local
echo ":: DONE"

# use parameter to decide if .xinitrc is needed to be installed into system
# todo
if [ $# -eq 1 ]; then
	[ $1 = "--dwm" ] && (echo ":: Installing .xinitrc." && ln -s -f $HOME/.dotfiles/.xinitrc $HOME/.xinitrc && echo ":: DONE")
fi

#
# effect it
#source ~/.zshrc
# exec zsh -l

# asking user to reluach the terminal
echo "Installation completed!"
echo "================================================================================="
echo "================ PLEASE RELAUNCH YOUR TERMINAL TO USE ZSH ======================="
echo "================================================================================="
