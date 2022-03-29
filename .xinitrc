xset r rate 500 30

# Set up background
/home/gong/.fehbg &

# Statusbar 
dwmstatus 2>&1 >/dev/null &
#while true; do
#    xsetroot -name "$( date +"%F %R" )"
#    sleep 1m
#done &

# start dwm
exec /usr/local/bin/startdwm
#exec dwm
