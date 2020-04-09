#!/bin/bash

echo '[Unit]
Description=Run script at first startup after all services are loaded
After=default.target

[Service]
Type=simple
#RemainAfterExit=no means there is no need to stop it at a later point
RemainAfterExit=no
ExecStart=/tmp/firstboot.sh
#TimeoutStartSec=0 probably not needed

[Install]
WantedBy=default.target
' > /etc/systemd/system/firstboot.service

echo '#!/bin/bash
touch /home/enforge/test
' > /tmp/firstboot.sh