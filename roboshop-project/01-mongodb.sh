#!/bin/bash

ami_id="ami-0055977a6e828a4f4"
instance_type="t3.micro"
domain_name="mahender.org"
hosted_zone_id="Z05213281AEN8G0889PWV"

for instance in $@
do

    echo "Creating security group for $instance"

    sg_id=$(aws ec2 create-security-group \
        --group-name "roboshop-$instance" \
        --description "Security group for roboshop $instance" \
        --query 'GroupId' \
        --output text) || exit 1
        echo "Security group ID: $sg_id"

    echo "Allow Port 27017 for $instance"

    aws ec2 authorize-security-group-ingress \
        --group-id $sg_id \
        --protocol tcp \
        --port 27017 \
        --cidr 0.0.0.0/0 || exit 1

    echo "Creating instance: $instance"

    instance_id=$(aws ec2 run-instances \
            --image-id $ami_id \
            --instance-type $instance_type \
            --security-groups "roboshop-common" "${sg_id}" \
            --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=roboshop-$instance}]" \
            --query 'Instances[0].InstanceId' \
            --output text
    )

    echo "$instance instance ID: $instance_id"

    if [ $instance != "frontend" ]; then
        IP=$( aws ec2 describe-instances --instance-ids $instance_id \
             --query 'Reservations[].Instances[].PrivateIpAddress' --output text
        )
        r53_record="${instance}.${domain_name}"
    else
        IP=$( aws ec2 describe-instances --instance-ids $instance_id \
             --query 'Reservations[].Instances[].PublicIpAddress' --output text
        )
        r53_record="${domain_name}"
    fi

    # update R53 record
    echo "Record: ${r53_record}"
    aws route53 change-resource-record-sets \
    --hosted-zone-id $hosted_zone_id \
    --change-batch '{
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": "'$r53_record'",
                    "Type": "A",
                    "TTL": 1,
                    "ResourceRecords": [{"Value": "'$IP'"}]
                }
            }
        ]
    }'

    echo "Updated R53 record for $instance"
done