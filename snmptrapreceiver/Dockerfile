FROM centos:8

MAINTAINER Ed Presutti, https://github.com/ekrunch

RUN dnf -y install net-snmp net-snmp-utils

RUN sed -i 's/# authCommunity/authCommunity/g' /etc/snmp/snmptrapd.conf

ADD startsnmpd.sh /

CMD ["/startsnmpd.sh"]

EXPOSE 1161/udp
EXPOSE 1161/tcp
EXPOSE 1162/udp
EXPOSE 1162/tcp
