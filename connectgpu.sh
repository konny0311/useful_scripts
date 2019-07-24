#!/bin/bash
ENV_INSTANCE=$1
if [ ${ENV_INSTANCE} = EC2TMP ]; then
    INSTANCE=${EC2TMP}
    echo the instance is EC2TMP
else
    INSTANCE=${EC2TRAINING}
    echo the instance is EC2TRAINING
fi
CORRECTSTATE=running
STATE=`aws ec2 describe-instances --instance-ids ${INSTANCE} | jq -r '. | .Reservations[].Instances[].State.Name'`
echo the server state is ${STATE}
if [ ${STATE} = ${CORRECTSTATE} ]; then
    echo connect to the instance
    PUBLICIP=`aws ec2 describe-instances --instance-ids ${INSTANCE} | jq -r '. | .Reservations[].Instances[].PublicIpAddress'`
    echo public ip is ${PUBLICIP}. connecting the remote server
    # connect remote server
    ssh -i ${AWS_PEM} ubuntu@${PUBLICIP}

else
    echo please check the instance state
fi
