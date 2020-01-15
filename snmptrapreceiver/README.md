# snmptrapreceiver
A very simple SNMP trap receiver. Uses the CentOS 8 image as a base.

Receives traps on public and they're logged in /var/log/snmp/snmptrapd.log. That log is tailed to the console so you can see the trap output as they happen in Openshift. Ports are remapped to 1161/tcp and 1161/udp for SNMPd, 1162/tcp and 1162/udp for SNMPTrapd. This is done because of the low port restriction. This container doesn't run as root so the usual 161/162 won't work.

My recommendation would be to put a LoadBalancer in front of the cluster and map the ports. I do this with the free Kemp LoadMaster appliance and map the real 161/162 ports to their counterparts in the cluster. My nodePort service configuration is provided in this repo. Ideally a real load balancer mapped to Openshift would be more ideal as nodePort exposes the service on all nodes and it's difficult to tell if it's actually working or not. But this set up suffices for an example.

