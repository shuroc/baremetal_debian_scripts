apt-get install coreutils -y
apt-get install ntp -y
echo "to manually resync time use either\n  service ntp restart\nor\n  service ntp stop; ntpd -q; service ntp start"