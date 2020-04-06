#!/bin/bash
NAME=$1

echo "Deleting stack ${NAME}..."
aws cloudformation delete-stack \
--stack-name ${NAME}