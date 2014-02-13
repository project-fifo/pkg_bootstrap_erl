#!/usr/bin/bash

case $2 in
    DEINSTALL)
        echo "Putting a shutdown in here would be cool!"
	;;
    POST-DEINSTALL)
	echo "This should delete all created files that need to be gone."
	echo "only applies for things created by the install script."
	;;
esac
