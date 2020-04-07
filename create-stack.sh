#!/bin/bash
# create-stack.sh
# This script creates or updates a cloudformation stack. See usage ./create-stack.sh -h
# 
# Martin Ansong
usage="Usage: $(basename "$0") stack-name template-file parameter-file region [aws-cli-opts]

where:
  stack-name     - the stack name
  template-file  - the cloudformation template file
  parameter-file - json file with parameters
  region         - the AWS region
  aws-cli-opts   - extra options passed directly to create-stack/update-stack
"

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "help" ] || [ "$1" == "usage" ]; then
  echo "$usage"
  exit -1
fi

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] ; then
  echo "$usage"
  exit -1
fi

NAME=$1
FILE=$2
PARAM_FILE=$3
REGION=$4
DIR="$(PWD)"

function create_stack () {
    aws cloudformation create-stack \
    --stack-name ${NAME} \
    --template-body file://${DIR}/${FILE} \
    --parameters file://${DIR}/${PARAM_FILE} \
    --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
    --region ${REGION}
}

function wait_stack () {
    echo "Waiting for stack to be created..."
    aws cloudformation wait stack-create-complete \
    --region ${REGION} \
    --stack-name ${NAME}
}

function update_stack () {
    aws cloudformation update-stack \
    --stack-name ${NAME} \
    --template-body file://${DIR}/${FILE} \
    --parameters file://${DIR}/${PARAM_FILE} \
    --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
    --region ${REGION}
}

function delete_stack () {
    echo "Deleting stack ${NAME}..."
    aws cloudformation delete-stack \
    --stack-name ${NAME}
}

echo "Checking if stack ${NAME} exists..."

if ! aws cloudformation describe-stacks --region ${REGION} --stack-name ${NAME} ; then
    echo "Stack does not exist.., Creating stack ${NAME}..."
    create_stack
    wait_stack
else
    echo "Stack exists, attempting update..."
    update_result=`update_stack 2>&1`
    status=$?
    if [ $status -ne 0 ] ; then
            if [[ $update_output == *"ValidationError"* && $update_output == *"No updates"* ]] ; then
                echo -e "\nFinished create/update - no updates to be performed"
                exit 0;
            elif [[ $update_output == *"ValidationError"* && $update_output == *"ROLLBACK_COMPLETE"* ]] ; then
                echo -e "\nStack is in ROLLBACK_COMPLETE state so can not be updated. Deleting and Recreating stack"
                delete_stack
                create_stack
                exit 0;
            fi
    fi
fi

echo "Finished creating/updating stack ${NAME}"
