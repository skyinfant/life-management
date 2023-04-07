#!/bin/bash
#备份life-management

cd `dirname $0`

zip -ry life-management.zip ../../life-management -x \*.mp3 \*.git/\*

sz life-management.zip

/usr/bin/rm -rf life-management.zip

cd ../


sh life-management.sh
