FROM centos:7

MAINTAINER Ed Presutti, https://github.com/ekrunch

ADD MariaDB.repo /etc/yum.repos.d/
RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
RUN yum -y install MariaDB-server galera-4 MariaDB-client MariaDB-shared MariaDB-backup MariaDB-common

# Note : This is an example only
ADD plugin-load.cnf /etc/my.cnf.d

ADD startmariadb.sh /
CMD ["/startmariadb.sh"]

EXPOSE 3306/tcp
