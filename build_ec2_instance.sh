#!/bin/bash
set -Eeuo pipefail

# ==========================================
# AWS EC2 Configuration
# ==========================================
REGION="us-east-1"
AMI_ID="ami-0220d79f3f480ecf5"  # Replace with your custom AMI ID
INSTANCE_TYPE="t3.micro"
INSTANCE_NAME="Test-Inatance"
SG_NAME="Test-SG"

# ==========================================
# Detect Public IP
# ==========================================
echo "Detecting public IP..."

MY_IP=$(curl -4 -fsS https://checkip.amazonaws.com | tr -d '[:space:]')
MY_CIDR="${MY_IP}/32"

echo "Your public IP: $MY_CIDR"

# ==========================================
# Validate AWS Credentials
# ==========================================
aws sts get-caller-identity --region "$REGION" >/dev/null

# ==========================================
# Validate Custom AMI
# ==========================================
AMI_STATE=$(aws ec2 describe-images \
    --region "$REGION" \
    --image-ids "$AMI_ID" \
    --query 'Images[0].State' \
    --output text)

if [[ "$AMI_STATE" != "available" ]]; then
    echo "ERROR: Custom AMI is not available: $AMI_ID"
    exit 1
fi

echo "Custom AMI validated: $AMI_ID"

# ==========================================
# Get Default VPC
# ==========================================
VPC_ID=$(aws ec2 describe-vpcs \
    --region "$REGION" \
    --filters "Name=isDefault,Values=true" \
    --query 'Vpcs[0].VpcId' \
    --output text)

if [[ "$VPC_ID" == "None" || -z "$VPC_ID" ]]; then
    echo "ERROR: No default VPC found in $REGION"
    exit 1
fi

# ==========================================
# Get Default Subnet
# ==========================================
SUBNET_ID=$(aws ec2 describe-subnets \
    --region "$REGION" \
    --filters \
      "Name=vpc-id,Values=$VPC_ID" \
      "Name=default-for-az,Values=true" \
    --query 'Subnets[0].SubnetId' \
    --output text)

if [[ "$SUBNET_ID" == "None" || -z "$SUBNET_ID" ]]; then
    echo "ERROR: No default subnet found"
    exit 1
fi

# ==========================================
# Create Security Group
# ==========================================
SG_ID=$(aws ec2 create-security-group \
    --region "$REGION" \
    --group-name "${SG_NAME}-$(date +%s)" \
    --description "SSH allowed only from my public IP" \
    --vpc-id "$VPC_ID" \
    --query 'GroupId' \
    --output text)

echo "Security Group created: $SG_ID"

# ==========================================
# Allow SSH from Your IP Only
# ==========================================
aws ec2 authorize-security-group-ingress \
    --region "$REGION" \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 22 \
    --cidr "$MY_CIDR"

echo "SSH allowed from $MY_CIDR"

# ==========================================
# Create EC2 Instance Without Key Pair
# ==========================================
INSTANCE_ID=$(aws ec2 run-instances \
    --region "$REGION" \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --subnet-id "$SUBNET_ID" \
    --security-group-ids "$SG_ID" \
    --associate-public-ip-address \
    --count 1 \
    --tag-specifications \
      "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "EC2 instance launched: $INSTANCE_ID"

# ==========================================
# Wait for Instance to Run
# ==========================================
aws ec2 wait instance-running \
    --region "$REGION" \
    --instance-ids "$INSTANCE_ID"

# ==========================================
# Display Instance Information
# ==========================================
aws ec2 describe-instances \
    --region "$REGION" \
    --instance-ids "$INSTANCE_ID" \
    --query 'Reservations[0].Instances[0].{
        InstanceId:InstanceId,
        State:State.Name,
        AMI:ImageId,
        PublicIP:PublicIpAddress,
        PrivateIP:PrivateIpAddress,
        InstanceType:InstanceType,
        KeyPair:KeyName,
        SecurityGroups:SecurityGroups[*].GroupId
    }' \
    --output table

echo "=========================================="
echo "EC2 instance created successfully!"
echo "AMI: $AMI_ID"
echo "SSH source: $MY_CIDR"
echo "Security Group: $SG_ID"
echo "Instance ID: $INSTANCE_ID"
echo "No SSH key pair was attached."
echo "=========================================="
