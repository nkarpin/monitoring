#!/bin/bash

#DEVSTACK HOST Properties
DEVSTACK_PATH="/opt/stack/devstack/"
DEVSTACK_CONF="$DEVSTACK_PATH/local.conf"
DEVSTACK_HOST_IP=`grep HOST_IP $DEVSTACK_CONF | cut -f 2 -d =`
DEVSTACK_HOST_NAME=`hostname -f`

#ZABBIX SETTINGS
ZABBIX_RELEASE="2.4"
RELEASE_REPO="http://repo.zabbix.com/zabbix/$ZABBIX_RELEASE/ubuntu/pool/main/z/zabbix-release/zabbix-release_$ZABBIX_RELEASE-1+trusty_all.deb"

#Change ZABBIX_SERVER value to IP or DNS name of your infra monitoring Zabbix server or Zabbix proxy
ZABBIX_SERVER=server.domain.tld
PARAMS_DIR=/etc/zabbix/zabbix_agentd.d

#INSTALL ZABBIX AGENT
REPO_FILE=`mktemp`

wget "$RELEASE_REPO" -qO $REPO_FILE && sudo dpkg -i $REPO_FILE
rm $REPO_FILE
apt-get update && apt-get install zabbix-agent
service zabbix-agent stop

#GENERATE ZABBIX USERPARAMETERS
#keystone
echo "UserParameter=keystone.api.status,/etc/zabbix/scripts/check_api.py keystone http $DEVSTACK_HOST_IP 5000" > "$PARAMS_DIR/keystone_api_status.conf"
echo "UserParameter=keystone.service.api.status,/etc/zabbix/scripts/check_api.py keystone_service http $DEVSTACK_HOST_IP 35357" > "$PARAMS_DIR/keystone_service_api_status.conf"

#cinder
echo "UserParameter=cinder.api.status,/etc/zabbix/scripts/check_api.py cinder http $DEVSTACK_HOST_IP 8776" > "$PARAMS_DIR/cinder_api_status.conf"

#neutron
echo "UserParameter=neutron.api.status,/etc/zabbix/scripts/check_api.py neutron http $DEVSTACK_HOST_IP 9696" > "$PARAMS_DIR/neutron_api_status.conf"

#glance
echo "UserParameter=glance.api.status,/etc/zabbix/scripts/check_api.py glance http $DEVSTACK_HOST_IP 9292" > "$PARAMS_DIR/glance_api_status.conf"

#nova
echo "UserParameter=nova.api.status,/etc/zabbix/scripts/check_api.py nova_os http $DEVSTACK_HOST_IP 8774" > "$PARAMS_DIR/nova_api_status.conf"

cp -r scripts /etc/zabbix/

cp check_api.conf /etc/zabbix/

mv /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf_old

cp zabbix_agentd.conf /etc/zabbix/

sed -i "s/%HOSTNAME%/$DEVSTACK_HOST_NAME/g" /etc/zabbix/zabbix_agentd.conf

sed -i "s/%ZABBIXSERVER%/$ZABBIX_SERVER/g" /etc/zabbix/zabbix_agentd.conf

service zabbix-agent start