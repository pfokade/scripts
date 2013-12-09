#!/bin/bash
## === PATH config ===
CURRENT_PATH=$(pwd)
DOMAIN_NAME=$1


## === checked DOMAIN_NAME  ===
if [ -z ${DOMAIN_NAME} ]; then
	echo "No Domain name!!"
	echo "Abort!!"
	exit 1
fi

## === checked stud config file  ===

if [ ! -f /etc/stud/${DOMAIN_NAME}.conf ]; then
	echo "No stud configure file [/etc/stud/${DOMAIN_NAME}.conf]!!"
	echo "Abort!!"
	exit 1
fi

## === checked pem file path  ===
pem_filepath=$(grep "CERT=" /etc/stud/${DOMAIN_NAME}.conf | cut -d'=' -f2 | sed -e 's/"//g')
date_suffix=$(date '+%Y%m%d')


if [ ! -f ${pem_filepath}_${date_suffix} ]; then
	echo "No Backuped PEM file [${pem_filepath}_${date_suffix}]!!"
	echo "Abort!!"
	exit 1
fi

## === recovery pem file and restart stud ===

echo ""
echo "============================================="
echo "recovery from backuped PEM file and restart stud deamon"
echo "============================================="
echo ""

cp ${pem_filepath}_${date_suffix} ${pem_filepath}
if [ $? != 0 ]; then
	echo "Failed!!"
	exit 1
fi

echo "--- before ---"
netstat -na | grep ':443 '
echo "--- ---"

/etc/init.d/stud restart
sleep 1

echo "--- after ---"
netstat -na | grep ':443 '
echo "--- ---"

echo "finish!!"
echo ""

