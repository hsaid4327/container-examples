#!/bin/bash

#touch /tmp/snmptrap.log

echo Starting snmpd
. /etc/sysconfig/snmpd && /usr/sbin/snmpd tcp:1161 udp:1161 -Lo &

echo Starting snmptrapd
. /etc/sysconfig/snmptrapd && /usr/sbin/snmptrapd tcp:1162 udp:1162 -Lo &
#. /etc/sysconfig/snmptrapd && /usr/sbin/snmptrapd tcp:1162 udp:1162 -Lf /tmp/snmptrap.log &

tail -f /dev/null
