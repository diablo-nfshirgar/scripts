#!/usr/bin/env bash
set -ex

#Recording start time
START_TIME="$(date +%F_%H:%M:%S)"

#Log Directory & log file definition
LOG_DIR="$PWD"

LOG_FILE="${LOG_DIR}/alicloud_security_groups_list_${START_TIME}.log"

echo "================================ Beginning gathering Security group rules in Alicloud at $START_TIME ================================" >> ${LOG_FILE}

Region_ID="eu-central-1 ap-southeast-1"

for i in $Region_ID

do

  echo "======================================================= $i ============================================================" >> ${LOG_FILE}

  Vpc_IDs=$(aliyun vpc DescribeVpcs --RegionId $i --DryRun false | jq '.Vpcs.Vpc[].VpcId' | tr -d '""')

  for j in $Vpc_IDs

  do

    echo "============================ $j ==================================" >> ${LOG_FILE}

    Security_groups=$(aliyun ecs DescribeSecurityGroups --RegionId $i --VpcId $j --NetworkType vpc --DryRun false | jq '.SecurityGroups.SecurityGroup[].SecurityGroupId' | tr -d '""') >> ${LOG_FILE}

    for k in $Security_groups

    do

      echo "============================ $k ==================================" >> ${LOG_FILE}

      aliyun ecs DescribeSecurityGroupAttribute --RegionId $i --SecurityGroupId $k --Direction ingress --output cols=SourceCidrIp,PortRange rows=Permissions.Permission >> ${LOG_FILE}

    done

  done

done

#Recording end time
END_TIME="$(date +%F_%H:%M:%S)"

echo "================================ Finished gathering Security group rules in Alicloud at $END_TIME  ================================" >> ${LOG_FILE}
