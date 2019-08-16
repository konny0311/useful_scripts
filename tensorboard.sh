INSTANCE=${} # put env variable of your instance id here
CORRECTSTATE=running
STATE=`aws ec2 describe-instances --instance-ids ${INSTANCE} | jq -r '. | .Reservations[].Instances[].State.Name'`
echo the server state is ${STATE}
if [ ${STATE} = ${CORRECTSTATE} ]; then
    PUBLICIP=`aws ec2 describe-instances --instance-ids ${INSTANCE} | jq -r '. | .Reservations[].Instances[].PublicIpAddress'`
    echo port-forwarding with ${PUBLICIP}. access to http://localhost:6006
    ssh -i ${PEM} -NL 6006:localhost:6006 ubuntu@${PUBLICIP}
else
    echo cannot port-forward for tensorboard
fi
