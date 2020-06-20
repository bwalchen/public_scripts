#!/bin/sh
# Startup script doesn't only run once. Can run at other times too.
# Only run if script hasn't been downloaded yet. 
if [ ! -f "/tmp/root/renew_wan_dhcp_script.sh" ]
then
    cd /tmp/root
    wget https://raw.githubusercontent.com/bwalchen/public_scripts/master/renew_wan_dhcp_script.sh
    chmod u+x renew_wan_dhcp_script.sh
    /tmp/root/renew_wan_dhcp_script.sh &
fi
