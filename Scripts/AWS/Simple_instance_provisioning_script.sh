#!/bin/bash

# Automate EC2 instance provisioning. This script will assume AWS credentials are already setup using `aws configure` command

# User input for instance parameters
read -p "Enter instance name: " INSTANCE_NAME
read -p "Enter instance type: " INSTANCE_TYPE
read -p "Enter region: " REGION
read -p "Enter security group ID: " SECURITY_GROUP_ID
read -p "Enter key pair name: " KEY_PAIR_NAME

# Create EC2 instance
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id ami-xxxxxxxxxxxxxxxxx \
  --instance-type "${INSTANCE_TYPE}" \
  --region "${REGION}" \
  --security-group-ids "${SECURITY_GROUP_ID}" \
  --key-name "${KEY_PAIR_NAME}" \
  --output json \
  --query 'Instances[0].InstanceId')

# Add tags to the instance for easy identification
aws ec2 create-tags \
  --resources "${INSTANCE_ID}" \
  --tags Key=Name,Value="${INSTANCE_NAME}"

echo "EC2 instance '${INSTANCE_NAME}' created with Instance ID: ${INSTANCE_ID}"

