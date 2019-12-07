FROM centos:8

MAINTAINER Ed Presutti, https://github.com/ekrunch

RUN dnf -y install net-snmp net-snmp-utils

RUN sed -i 's/# authCommunity/authCommunity/g' /etc/snmp/snmptrapd.conf

CMD . /etc/sysconfig/snmpd && /usr/sbin/snmpd &
CMD . /etc/sysconfig/snmptrapd && /usr/sbin/snmptrapd &

EXPOSE 161:161/udp
EXPOSE 162:162/udp
