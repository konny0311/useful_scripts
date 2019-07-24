#!/bin/bash
# start gpu server
ENV_INSTANCE=$1
if [ ${ENV_INSTANCE} = EC2TMP ]; then
    INSTANCE=${EC2TMP}
    echo the instance is EC2TMP
else
    INSTANCE=${EC2TRAINING}
    echo the instance is EC2TRAINING
fi
CORRECTSTATE=stopped
STATE=`aws ec2 start-instances --instance-ids ${INSTANCE} | jq -r '. | .StartingInstances[].PreviousState.Name'`
echo the server state is ${STATE}
if [ ${STATE} = ${CORRECTSTATE} ]; then
    echo starting the instance, wait 10sec
    # sleep 10sec
    sleep 10
    # get instance info and public IP
    PUBLICIP=`aws ec2 describe-instances --instance-ids ${INSTANCE} | jq -r '. | .Reservations[].Instances[].PublicIpAddress'`
    echo new public ip is ${PUBLICIP}. connecting the remote server
    echo ${PUBLICIP} | pbcopy
    echo ${PUBLICIP} is copied on clip board
    # connect remote server
    ssh -i ${AWS_PEM} ubuntu@${PUBLICIP}

else
    echo stop the server first, then restart it
fi
