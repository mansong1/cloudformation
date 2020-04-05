#!/bin/bash
NAME=$1
FILE=$2
DIR="$(PWD)"

aws cloudformation create-stack
--stack-name ${NAME}

--template-body file://${DIR}/${FILE}
--region=us-west-2