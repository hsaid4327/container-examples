#!/bin/bash

touch /snmptrap.log

. /etc/sysconfig/snmpd && /usr/sbin/snmpd tcp:1161 udp:1161 -Lo &
. /etc/sysconfig/snmptrapd && /usr/sbin/snmptrapd tcp:1162 udp:1162 -Lf /snmptrap.log &

tail -f /snmptrap.log
