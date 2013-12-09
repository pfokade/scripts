#!/bin/bash
## === PATH config ===
CURRENT_PATH=$(pwd)
DOMAIN_NAME=$1

## ===  checked DOMAIN_NAME ===
if [ -z ${DOMAIN_NAME} ]; then
	echo "No Domain name!!"
	echo "Abort!!"
	exit 1
fi

## === checked PEM file ===
if [ -f ./${DOMAIN_NAME}.pem ]; then
	echo "Exist ${DOMAIN_NAME}.pem file!!  Overwrite OK?(yes/no)"

	read proceed
	if [ _${proceed} != "_yes" ]; then
		echo "Abort!!"
		exit 1
	fi
fi

if [ -f ./${DOMAIN_NAME}.key ]; then
	echo "Exist ${DOMAIN_NAME}.key file!!  Overwrite OK?(yes/no)"

	read proceed
	if [ _${proceed} != "_yes" ]; then
		echo "Abort!!"
		exit 1
	fi
fi

if [ -f ./${DOMAIN_NAME}.crt ]; then
	echo "Exist ${DOMAIN_NAME}.crt file!!  Overwrite OK?(yes/no)"

	read proceed
	if [ _${proceed} != "_yes" ]; then
		echo "Abort!!"
		exit 1
	fi
fi


## === SET FILEs === 
echo "PFX file name ?"
read pfx_filename 
#pfx_filename="pf.ws-g.jp.pfx"
if [ ! -f ./${pfx_filename} ]; then
	echo "No exists PFX file!!"
	echo "Abort!!"
	exit 1
fi

echo "Intermediate CA file name ?"
read intermediate_ca_filename
#intermediate_ca_filename="CybertrustJapanPublicCAG2.cer"
if [ ! -f ./${intermediate_ca_filename} ]; then
	echo "No exists Intermediate CA file!!"
	echo "Abort!!"
	exit 1
fi

echo "CrossRoot CA file name ?"
read crossroot_ca_filename
#crossroot_ca_filename="BaltimoreCyberTrustRoot.cer"
if [ ! -f ./${crossroot_ca_filename} ]; then
	echo "No exist Intermediate CA file!!  Proceed?(yes/no)"

	read proceed
	if [ _${proceed} != "_yes" ]; then
		echo "Abort!!"
		exit 1
	fi
fi


## === PEX -> KEY, CER ===
echo ""
echo "============================================="
echo "create KEY and CRT from  PFX file"
echo "============================================="
echo ""

openssl pkcs12 -in ${pfx_filename} -out ${DOMAIN_NAME}.key -nocerts -nodes
if [ $? != 0 ]; then
	echo "Failed!!"
	exit 1
fi

openssl pkcs12 -in ${pfx_filename} -out ${DOMAIN_NAME}.crt -clcerts -nokeys
if [ $? != 0 ]; then
	echo "Failed!!"
	exit 1
fi


## ===  KEY, CERs -> PEM ===
echo ""
echo "============================================="
echo "create PEM file from KEY, CRT, Intermediate CA and Crossroot CA"
echo "============================================="
echo ""


cat ${DOMAIN_NAME}.key > ${DOMAIN_NAME}.pem
cat ${DOMAIN_NAME}.crt >> ${DOMAIN_NAME}.pem
cat ${intermediate_ca_filename} >> ${DOMAIN_NAME}.pem

if [ -f ./${crossroot_ca_filename} ]; then
	cat ${crossroot_ca_filename} >> ${DOMAIN_NAME}.pem
fi

cp ${DOMAIN_NAME}.pem ${DOMAIN_NAME}.pem.bak
tr -d '\r' < ${DOMAIN_NAME}.pem.bak > ${DOMAIN_NAME}.pem
rm -f ${DOMAIN_NAME}.pem.bak

echo "finish!!"
echo ""


