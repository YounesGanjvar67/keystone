#!/bin/bash
if [ -z $MYSQL_DB_HOST ]; then
        echo "Your'are using Remote MySQL Database; "
        echo "Please set MYSQL_DB_HOST when running a container."
        exit 1;
fi
if [ -z $KEYSTONE_HOST ]; then
        
        echo "Please set KEYSTONE_HOST when running a container."
        exit 1;
fi

setsid /scripts/keystone.sh > startuplog.txt & 
echo "start******************" &
exec /usr/sbin/init

 



