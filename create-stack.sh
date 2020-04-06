#!/bin/bash
NAME=$1
FILE=$2
PARAM_FILE=$3
REGION=$4
DIR="$(PWD)"

echo "Creating stack ${NAME}..."
aws cloudformation create-stack \
--stack-name ${NAME} \
--template-body file://${DIR}/${FILE} \
--parameters file://${DIR}/${PARAM_FILE} \
--capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
--region ${REGION}