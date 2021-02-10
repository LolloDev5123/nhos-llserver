#!/bin/bash

sleep 1
echo "`date` Local Log Sever is running..."

while true 1; do
  echo -ne "HTTP/1.0 200 OK\r\n\r\n `cat /mnt/nhos/index.html` `tail /var/log/nhos/nhm/miners/*.log /var/log/nhos/*.log` </textarea></body></html>" | nc -l -p 8080 > /tmp/server.log;
  # cat /tmp/server.log # debug only
  cat /tmp/server.log | grep "GET /reboot"
  if [ "${?}" -eq 0 ]; then
    sudo reboot
  fi
done
