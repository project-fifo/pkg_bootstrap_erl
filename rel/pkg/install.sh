#!/usr/bin/bash

USER=cool_stuff
GROUP=$USER
SERVICE=$USER

case $2 in
    PRE-INSTALL)
        #Check on image version if required
        if grep '^Image: base64 13.[23].*$' /etc/product
	then
	    echo "Image version supported"
	else
	    echo "This image version is not supported please use the base64 13.2.1 image."
	    exit 1
        fi
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
        ;;
    POST-INSTALL)
        echo Importing service ...
        svccfg import /opt/local/path/to/$SERVIRE.xml
        echo Could put stuff in here to copy files to places
        echo or do whatever tasks are needed post installation
        ;;
esac
