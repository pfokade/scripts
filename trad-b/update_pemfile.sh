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

## === checked new pem file  ===

if [ ! -f ./${DOMAIN_NAME}.pem ]; then
	echo "No PEM file [./${DOMAIN_NAME}.pem]!!"
	echo "Abort!!"
	exit 1
fi



## === checked pem file path  ===
pem_filepath=$(grep "CERT=" /etc/stud/${DOMAIN_NAME}.conf | cut -d'=' -f2 | sed -e 's/"//g')
date_suffix=$(date '+%Y%m%d')
##echo ${pem_filepath}
##echo ${date_suffix}

if [ -f ${pem_filepath} ]; then
	echo "backup to ${pem_filepath}_${date_suffix}"
	cp ${pem_filepath} ${pem_filepath}_${date_suffix}
	if [ $? != 0 ]; then
		echo "Failed!!"
		exit 1
	fi
fi

## === update pem file and restart stud ===

echo ""
echo "============================================="
echo "copy from new PEM file  and restart stud deamon"
echo "============================================="
echo ""

cp ./${DOMAIN_NAME}.pem ${pem_filepath}
if [ $? != 0 ]; then
	echo "Failed!!"
	exit 1
fi

echo "--- before ---"
netstat -na | grep ':443 ' | grep 'LISTEN'
echo "--- ---"

/etc/init.d/stud restart
sleep 1

echo "--- after ---"
netstat -na | grep ':443 ' | grep 'LISTEN'
echo "--- ---"

echo "finish!!"
echo ""

