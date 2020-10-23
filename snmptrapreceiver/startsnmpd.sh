#!/bin/bash

#touch /tmp/snmptrap.log test1

echo Starting snmpd
#. /etc/sysconfig/snmpd && /usr/sbin/snmpd tcp:1161 udp:1161 -Lo &
. /etc/sysconfig/snmpd && /usr/sbin/snmpd tcp:1161 udp:1161 -Lo -Lf /var/log/snmp/snmpd.log -C -c /etc/snmp/snmpd.conf

echo Starting snmptrapd
#. /etc/sysconfig/snmptrapd && /usr/sbin/snmptrapd tcp:1162 udp:1162 -Lo &
. /etc/sysconfig/snmptrapd && /usr/sbin/snmptrapd tcp:1162 udp:1162 -Lo -Lf /var/log/snmp/snmptrapd.log -C -c /etc/snmp/snmptrapd.conf

tail -f /var/log/snmp/snmptrapd.log
