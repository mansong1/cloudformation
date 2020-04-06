#!/bin/bash
NAME=$1

aws cloudformation delete-stack \
--stack-name ${NAME}