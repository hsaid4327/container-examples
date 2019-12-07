#!/bin/bash

. /etc/sysconfig/snmpd && /usr/sbin/snmpd &
. /etc/sysconfig/snmptrapd && /usr/sbin/snmptrapd &
