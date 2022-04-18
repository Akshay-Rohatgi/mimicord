#!/bin/bash

if [ ! -f mimicord.service ]; then
	cp -f mimicord.service /etc/systemd/system/mimicord.service
else
    # wget -O /tmp/mimicord.service <>
    cp -f mimicord.service /etc/systemd/system/mimicord.service
fi


if [ -f mimicord.sh ]; then
	:
else
    :
    # wget -O /tmp/mimicord.sh <> 
fi

sed -i "s/ExecStart.*/ExecStart=bash /tmp/mimicord.sh $1/g"
systemctl daemon-reload

systemctl start mimicord.service 
