/bin/ip link set wlan0 up
if grep -q 0 /sys/class/net/wlan0/carrier
then
killall wpa_supplicant
/sbin/wpa_supplicant -B -i wlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf  > /dev/null 2>&1
/sbin/dhclient -r
/sbin/dhclient  > /dev/null 2>&1
fi