# snmptrapreceiver Deployment
Scripts to deploy the SNMP trap receiver. These are built around Openshift. Openshift has a system to build a container from a Dockerfile and this system uses that mechanism.

To use with k8s, please build the container from the provided Dockerfile deploy it into k8s and use the serice object created here. A Deployment will have to be created manually and the pod selector in the service may need to be adjusted accordingly.
