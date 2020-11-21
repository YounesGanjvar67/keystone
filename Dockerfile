FROM centossystemctl:7

###################### ENV ########################
ENV KEYSTONE_DB_ROOT_PASSWD admin
ENV KEYSTONE_DB_USER=root
ENV KEYSTONE_DB_PASSWD keystone

###################################################
################ yum install ######################
RUN yum install centos-release-openstack-train -y 
#RUN yum upgrade -y
RUN yum install python-openstackclient -y

RUN yum install mariadb -y
RUN yum install python2-PyMySQL  -y

RUN yum install memcached python-memcached -y;systemctl enable memcached.service
RUN yum install openstack-keystone httpd mod_wsgi -y
RUN yum install nano -y

###################################################
################ COPY ######################
WORKDIR scripts
COPY openstack.cnf /etc/my.cnf.d/openstack.cnf
COPY keystone.conf .
COPY keystone.sql .
COPY keystone.sh .
COPY bootstrap.sh .
COPY memcached .
RUN chmod 777 *
############################################

RUN rm -f /etc/sysconfig/memcached
RUN mv /scripts/memcached /etc/sysconfig/memcached 

RUN rm -f  /etc/keystone/keystone.conf
RUN mv /scripts/keystone.conf /etc/keystone/

###############EXPOSE ############################
EXPOSE 5000


################ CMD ######################

CMD ["/scripts/bootstrap.sh"]



