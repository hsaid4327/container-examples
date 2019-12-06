FROM ubi8/ubi

dnf -y install net-snmp net-snmp-utils

sed -i 's/# authCommunity/authCommunity/g' /etc/snmp/snmptrapd.conf

systemctl restart snmpd
systemctl restart snmptrapd

systemctl enable snmpd
systemctl enable snmptrapd

firewall-cmd --add-service=snmp --add-service=snmptrap --permanent --zone=public
firewall-cmd --reload

