#!/usr/bin/env bash
set -ex

#Source OpenRC file
source admin-openrc.sh

#Define hostname
HOST=`hostname -s`

#Recording start time
START_TIME="$(date +%F_%H:%M:%S)"

#Log Directory & log file definition
LOG_DIR="/opt/openstack/logs"

mkdir -p ${LOG_DIR}

LOG_FILE="${LOG_DIR}/volume_cleanup_${START_TIME}.log"

echo "============== Beginning volume cleanup on $HOST at $START_TIME ==============" >> ${LOG_FILE}

OPENSTACK_VOLUME_LIST=$(openstack volume list --column ID --format value)
for i in $OPENSTACK_VOLUME_LIST;
do

  echo "============================ $i ==================================" >> ${LOG_FILE}

  VOLUME_STATUS=$(openstack volume show $i --column status --format value)

  if [[ ! $VOLUME_STATUS =~ ^(in-use|reserved|backing-up|extending)$ ]]

    then

        echo "Volume is not in use, hence proceeding with the clean-up" >> ${LOG_FILE}
        if [[ $VOLUME_STATUS != "available" ]]

          then

              echo "Volume is in $VOLUME_STATUS state. resetting the status to available" >> ${LOG_FILE}
              cinder reset-state --state available $i

              echo "Deleting the volume with ID $i" >> ${LOG_FILE}
              openstack volume delete $i
              if [ $? -eq 0 ];
                then
                  echo "Volume successfully deleted" >> ${LOG_FILE}
                else
                  echo "Volume with ID $i failed to delete. Please check..." >> ${LOG_FILE}
              fi

          else

              echo "Deleting the volume with ID $i" >> ${LOG_FILE}
              openstack volume delete $i
              if [ $? -eq 0 ];
                then
                  echo "Volume successfully deleted" >> ${LOG_FILE}
                else
                  echo "Volume with ID $i failed to delete. Please check..." >> ${LOG_FILE}
              fi

        fi

    else

        echo "Volume with ID $i is in $VOLUME_STATUS status. Hence not deleting it" >> ${LOG_FILE}

  fi
done

#Recording end time
END_TIME="$(date +%F_%H:%M:%S)"

echo "============= Finished volume cleanup on $HOST at $END_TIME  ==============" >> ${LOG_FILE}
