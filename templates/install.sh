#!/usr/bin/bash

USER=APPID
GROUP=$USER
SERVICE=$USER

case $2 in
    PRE-INSTALL)
        #Create group and user if required!
        if grep "^$GROUP:" /etc/group > /dev/null 2>&1
        then
            echo "Group already exists, skipping creation."
        else
            echo Creating $GROUP group ...
            groupadd $GROUP
        fi
        if id $USER > /dev/null 2>&1
        then
            echo "User already exists, skipping creation."
        else
            echo Creating $USER user ...
            useradd -g $GROUP -d /var/db/$SERVICE -s /bin/false $USER
        fi
        mkdir /var/log/$SERVICE
        mkdir /var/db/$SERVICE
        chown $USER:$GROUP /var/log/$SERVICE /var/db/$SERVICE
        ;;
    POST-INSTALL)
        echo Importing service ...
        svccfg import /opt/local/$SERVICE/share/$SERVICE.xml
        echo Could put stuff in here to copy files to places
        echo or do whatever tasks are needed post installation
        ;;
esac
