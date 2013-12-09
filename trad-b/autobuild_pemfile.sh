#!/bin/bash
## === PATH config ===
CURRENT_PATH=$(pwd)
DOMAIN_NAME=$1


## === checked DOMAIN_NAME  ===
if [ -z ${DOMAIN_NAME} ]; then
	echo "No Domain name!!"
	echo "Abort!!"
	exit
fi


sh ./create_pemfile.sh ${DOMAIN_NAME}
if [ $? != 0 ]; then
        echo "create_pemfile Failed!!"
        exit
fi

sh ./update_pemfile.sh ${DOMAIN_NAME}
if [ $? != 0 ]; then
        echo "update_pemfile Failed!!"
        exit
fi

echo "auto build finish!!"
echo ""

