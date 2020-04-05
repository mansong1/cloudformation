#!/bin/bash
NAME=$1
FILE=$2
REGION=$3
DIR="$(PWD)"

aws cloudformation create-stack \
--stack-name ${NAME} \
--template-body file://${DIR}/${FILE} \
--region ${REGION}