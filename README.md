# .my-terminal
This conbines `.zshrc` and `.tmux.conf.local`. They need to be installed separately to `~/` as `.zshrc` and `.tmux.conf.local`. This is based on the two famous projects below.

## tmux 
`https://github.com/gpakosz/.tmux` is the project called `ohmytmux`. To use this project, you need to
```bash
cd ~
git clone https://github.com/gpakosz/.tmux
ln -s -f .tmux/.tmux.conf	# link to the config file from this project
```

>	It's strongly suggested that **~/.tmux.conf** file should not be modified, and modify **~/.tmux.conf.local** instead to override the default settings with your own key bindings.

So I have placed my own `.tmux.conf.local` here, and to make it work, do

```
cd ~
ln -s -f .my-terminal/.tmux.conf.local
```

I have set my own key bindings of spliting window as below: (this is the main function I will be using with tmux)
```
# -- user customizations -------------------------------------------------------
# this is the place to override or undo settings
bind | split-window -h
bind - split-window -v 

```
There's also settings for status line you can customized if you would like to.

	
## zsh
`https://github/ohmyzsh/ohmyzsh` is a very famous zsh shell template. I added some alias and variables on top of the original project.

To make it work, first you need to download `ohmyzsh` into your `~` folder and then download this project.
Please follow [here](https://github.com/ohmyzsh/ohmyzsh) to install ohmyzsh. After that is done, do 

```shell
cd ~
git clone https://github.com/happy42779/.my-terminal.git
ln -s -f .my-terminal/.zshrc
```
To install the following plugins:
   git
   zsh-autosuggestions
   `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-autosuggestions`
   zsh-syntax-highlighting:
   `git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-syntax-highlighting`
   zsh-completions:   
   `git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions`
   web-search
   vi-mode
   z
   dirhistory
   copybuffer
   copyfile


