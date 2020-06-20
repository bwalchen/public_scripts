#!/bin/sh
INTERVAL=10
PACKETS=1
UDHCPC="udhcpc -i vlan1 -p /var/run/udhcpc.pid -s /tmp/udhcpc"
IFACE=vlan1


ME=`basename $0`
RUNNING=`ps | awk '/'"$ME"'/ {++x}; END {print x+0}'`
if [ "$RUNNING" -gt 3 ]; then
   echo "Another instance of \"$ME\" is running"
   exit 1
fi

while sleep $INTERVAL
do
   TARGET=`ip route | awk '/default via/ {print $3}'`
   RET=`ping -c $PACKETS $TARGET 2> /dev/null | awk '/packets received/ {print $4}'`

   if [ "$RET" -ne "$PACKETS" ]; then
      echo "Ping failed. Waiting 5 minutes."
      sleep 500
      echo "Releasing IP address on $IFACE"
   #send a RELEASE signal
      kill -USR2 `cat /var/run/udhcpc.pid` 2> /dev/null
   #ensure udhcpc is not running
      killall udhcpc 2> /dev/null
      echo "Renewing IP address: $IFACE"
      $UDHCPC
      echo "Waiting 10 s..."
      sleep 10
      echo "Rebooting now"
      reboot
   else
      echo "Network is up via $TARGET"
   fi
done
