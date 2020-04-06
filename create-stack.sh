#!/bin/bash
NAME=$1
FILE=$2
REGION=$3
DIR="$(PWD)"

echo "Creating stack ${NAME}..."
aws cloudformation create-stack \
--stack-name ${NAME} \
--template-body file://${DIR}/${FILE} \
--capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
--region ${REGION}