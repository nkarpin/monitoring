#!/bin/bash

#INSTALL ZABBIX AGENT

ZABBIX_RELEASE="2.4"
RELEASE_REPO="http://repo.zabbix.com/zabbix/$ZABBIX_RELEASE/ubuntu/pool/main/z/zabbix-release/zabbix-release_$ZABBIX_RELEASE-1+trusty_all.deb"
REPO_FILE=`mktemp`


wget "$RELEASE_REPO" -qO $REPO_FILE && sudo dpkg -i $REPO_FILE
rm $REPO_FILE
sudo apt-get update && sudo apt-get install zabbix-agent

#GENERATE USERPARAMETERS

HOST_IP=127.0.0.1
PARAMS_DIR=/etc/zabbix/zabbix_agentd.d

#keystone
echo "UserParameter=keystone.api.status,/etc/zabbix/scripts/check_api.py keystone http $HOST_IP 5000" > "$PARAMS_DIR/keystone_api_status.conf"
echo "UserParameter=keystone.service.api.status,/etc/zabbix/scripts/check_api.py keystone_service http $HOST_IP 35357" > "$PARAMS_DIR/keystone_service_api_status.conf"

#cinder
echo "UserParameter=cinder.api.status,/etc/zabbix/scripts/check_api.py cinder http $HOST_IP 8776" > "$PARAMS_DIR/cinder_api_status.conf"

#neutron
echo "UserParameter=neutron.api.status,/etc/zabbix/scripts/check_api.py neutron http $HOST_IP 9696" > "$PARAMS_DIR/neutron_api_status.conf"

#glance
echo "UserParameter=glance.api.status,/etc/zabbix/scripts/check_api.py glance http $HOST_IP 9292" > "$PARAMS_DIR/glance_api_status.conf"

#nova
echo "UserParameter=nova.api.status,/etc/zabbix/scripts/check_api.py nova_os http $HOST_IP 8774" > "$PARAMS_DIR/nova_api_status.conf"


cp -r scripts /etc/zabbix/
cp check_api.conf /etc/zabbix/

mv /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf_old
cp zabbix_agentd.conf /etc/zabbix/
