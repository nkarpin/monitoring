# Devstack monitoring deployment

deploy_zabbix_agent.sh script can be used to deploy zabbix agent on devstack hosts.

Main parameters of deploy_zabbix_agent.sh:

DEVSTACK_PATH - path to directory where devstack configuration is located
DEVSTACK_CONF - devstack configuration file
DEVSTACK_HOST_IP - IP used by Openstack services to listen for connections
DEVSTACK_HOST_NAME - FQDN of devstack host, where zabbix agent should be deployed

OPENSTACK_USER - User used for monitoring of Openstack services API. Should be created inside Openstack.
OPENSTACK_PASSWORD - password of OPENSTACK_USER
OPENSTACK_TENANT - tenant of OPENSTACK_USER

ZABBIX_RELEASE - version of zabbix release
RELEASE_REPO - URL of zabbix repository

ZABBIX_SERVER - FQDN or IP address of zabbix server/proxy to which devstack host is attached.

