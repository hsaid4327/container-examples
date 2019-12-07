FROM centos:8

MAINTAINER Ed Presutti, https://github.com/ekrunch

RUN dnf -y install net-snmp net-snmp-utils

RUN sed -i 's/# authCommunity/authCommunity/g' /etc/snmp/snmptrapd.conf

RUN systemctl restart snmpd
RUN systemctl restart snmptrapd

RUN systemctl enable snmpd
RUN systemctl enable snmptrapd

RUN firewall-cmd --add-service=snmp --add-service=snmptrap --permanent --zone=public
RUN firewall-cmd --reload

EXPOSE 161:161/udp
EXPOSE 162:162/udp
