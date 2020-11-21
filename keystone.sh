sleep 10s
echo "***************************start services********************************"
systemctl start  memcached.service
systemctl status  memcached.service
sed -i 's@KEYSTONE_DB_PASSWD@'"$KEYSTONE_DB_PASSWD"'@'  /etc/keystone/keystone.conf
sed -i 's@MYSQL_DB_HOST@'"$MYSQL_DB_HOST"'@'  /etc/keystone/keystone.conf
sed -i 's@KEYSTONE_DB_PASSWD@'"$KEYSTONE_DB_PASSWD"'@'  /scripts/keystone.sql


mysql -uroot -p$KEYSTONE_DB_ROOT_PASSWD -h $MYSQL_DB_HOST < /scripts/keystone.sql

echo "*************************Populate the Identity service database:********************************"
#Populate the Identity service database:
su -s /bin/sh -c "keystone-manage db_sync" keystone


echo "******************************Initialize Fernet key repositories:*********************************"
#Initialize Fernet key repositories:
 keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
 keystone-manage credential_setup --keystone-user keystone --keystone-group keystone


echo "******************************Bootstrap the Identity service:**************************************"
#Bootstrap the Identity service:
 keystone-manage bootstrap --bootstrap-password admin \
  --bootstrap-admin-url http://$KEYSTONE_HOST:5000/v3/ \
  --bootstrap-internal-url http://$KEYSTONE_HOST:5000/v3/ \
  --bootstrap-public-url http://$KEYSTONE_HOST:5000/v3/ \
  --bootstrap-region-id RegionOne


echo "***************************************Configure Apache2******************************************"
# Configure Apache2
sed -i 's@#ServerName www.example.com:80@'"ServerName 127.0.0.1"'@'  //etc/httpd/conf/httpd.conf
ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/


echo "**************************************Write openrc to disk*******************************************"
# Write openrc to disk
cat > /root/openrc <<EOF
 export OS_USERNAME=admin
 export OS_PASSWORD=admin
 export OS_PROJECT_NAME=admin
 export OS_USER_DOMAIN_NAME=Default
 export OS_PROJECT_DOMAIN_NAME=Default
 export OS_AUTH_URL=http://127.0.0.1:5000/v3
 export OS_IDENTITY_API_VERSION=3
EOF
chmod 777 /root/openrc 
 systemctl enable httpd.service
 systemctl start httpd.service
 systemctl status httpd.service
source  ./root/openrc


echo "****************************************Create the service project***************************************"
#Create the service project:
# openstack project create --domain default \
  #--description "Service Project" service

echo "*****************************************sample token*******************************************************"
#openstack --os-auth-url http://127.0.0.1:5000/v3  token issue
#openstack --os-auth-url http://127.0.0.1:5000/v3 \
 # --os-project-domain-name Default --os-user-domain-name Default \
  #--os-project-name admin --os-username admin token issue























































