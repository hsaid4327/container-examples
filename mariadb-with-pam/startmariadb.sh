#!/bin/bash

echo Starting MariaDB
/usr/bin/mysqld_safe & 

tail -f /dev/null
