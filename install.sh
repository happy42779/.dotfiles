#!/bin/dash
#############################################################################
# In order to make it compatible with different platforms, here the SHEBANG #
# is going to be changed into /bin/dash which is the default program for	#
# Debian.																	#
# !!!!!!!!!!!!!!!!!!SHOULD AVOID BASHISM FEATURES!!!!!!!!!!!!!!!!!!!!!!!!!!	#
#############################################################################

# --- A simple template for the automation checking and installing steps
# --- There could be more!

# installing zsh
#PACK='zsh'
#echo "Checking if $PACK is installed."
#if ! command -v $PACK 1> /dev/null
#then
#    echo "$PACK is not be found, installing..."
#	$PACKMANAGER $PACK
#else
#	echo "$PACK is installed, proceeding..."
#fi

# --- make a list of dependencies and then check all in one chunk of code
# TODO DONE

# --- to add checking of the result of each step, to make this robust
# TODO

# giving up to extract it from /etc/os-release
# just asking

PACKMANAGER=''
PACKS="curl git zsh tmux"

#while true; do
#	printf "What package manager do you use ? \n1. apt \n2. pacman \n3. homebrew\n"
#	read -p "Type your choice [1/2/3]: " choice
#	case $choice in
#		1) PACKMANAGER="apt install"
#			break;;
#		2) PACKMANAGER="pacman -S"
#			break;;
#		3) PACKMANAGER="brew install"
#			break;;
#		0) exit
#			break;;
#		*) echo "invalid choice!"
#	esac
#done

denpendency_not_met=''
echo ":: Checking dependencies..."
for PACK in $PACKS; do
	echo ":: Checking if $PACK is installed ..."
	if ! command -v $PACK 1>/dev/null; then
		echo "$PACK is not installed "
		#printf '\u274c\n'
		$dependency_not_met=true
	else
		echo "$PACK is installed "
		#printf '\u2714\n'
	fi
done

if [ "$dependency_not_met" = true ]; then
	echo "One or more dependencies are not met, please intall them first!"
	exit
fi

# changing shell to zsh, if current shell is not zsh
echo ":: Changing shell to zsh..."

shell=$(echo $SHELL)
[ ${shell##*/} = "zsh" ] && echo "zsh is already the default shell, skipping" || (chsh -s $(which zsh) && echo ":: DONE")

# checking if .oh-my-zsh exists
echo ":: Installing .ohmyzsh"
[ -d "$HOME/.oh-my-zsh" ] && echo ".oh-my-zsh folder exists, assuming it's installed correctly" || (echo ":: Installing ohmyzsh" && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && echo ":: DONE")

echo ":: Creating soft link... (.zshrc)"
ln -s -f $HOME/.dotfiles/.zshrc $HOME/.zshrc
echo ":: DONE"

#zsh-autosuggestions
#`git clone https://github.com/zsh-users/zsh-autosuggestions ${zsh_custom:-${zsh:-~/.oh-my-zsh}/custom}/plugins/zsh-autosuggestions`
#zsh-syntax-highlighting:
#`git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-syntax-highlighting`
#zsh-completions:
#`git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions`

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
echo "======================================================================================"
echo "===================== PLEASE RELAUNCH YOUR TERMINAL TO USE ZSH ======================="
echo "======================================================================================"
