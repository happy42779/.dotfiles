xset r rate 500 30

# Set up background
~/.fehbg &

# Statusbar 
#~/.local/bin/dwm_bar.sh
slstatus &

# fcitx input method
fcitx5 &

while true; do
    xsetroot -name "$( date +"%F %R" )"
    sleep 1m
done &

# set locale
export LANG=en_US.UTF-8
export LANGUAGE=en_US

# x compositor
picom -b --config ~/.config/picom.conf
# start dwm
exec /usr/local/bin/startdwm

