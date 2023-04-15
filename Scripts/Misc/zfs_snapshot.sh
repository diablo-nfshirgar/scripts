#!/bin/bash

#Recording Start Time
#STARTTIME=$(date +"%T")
start_time="$(date -u +%s)"

HOST=`hostname -s`

#Snapshot ID
SNAPSHOTID=${HOST}_containers_Snapshot

SNAPSHOT_NAME="${HOST} ZFS containers Snapshot"
DATE="`date +%m_%d_%Y`"
SNAPSHOT_HOME="/backup"
SNAPSHOT_DIR="${SNAPSHOT_HOME}/${HOST}"
if [ ! -d ${SNAPSHOT_DIR} ]; then mkdir -p ${SNAPSHOT_DIR}; fi
LOGDIR="/opt/script/zfs_snapshot"
if [ ! -d ${LOGDIR} ]; then mkdir -p ${LOGDIR}; fi
LOGFILE="${LOGDIR}/zfs_snapshot.log"

#Previous snapshot cleanup, if exist:
rm -f ${SNAPSHOT_DIR}/*.gz

#Snapshot start notification
echo -e "Snapshot ID : ${SNAPSHOTID} started at `date`" >> ${LOGFILE}

echo "===========================================" >> ${LOGFILE}
echo "${SNAPSHOT_NAME} Start Time : `date`" >> ${LOGFILE}
echo "===========================================" >> ${LOGFILE}

for i in `lxc list | awk '!/NAME/{ if ( $4 == "RUNNING" ) print $2}'`
do
   zfs snapshot lxd/containers/$i@$i.snap
done

echo "===========================================" >> ${LOGFILE}
echo "${SNAPSHOT_NAME} End Time : `date`" >> ${LOGFILE}
echo "===========================================" >> ${LOGFILE}

echo "Compressing the Snapshots and uploading it to NAS Share :`date`"  >> ${LOGFILE}

for i in `lxc list | awk '!/NAME/{ if ( $4 == "RUNNING" ) print $2}'`
do
   zfs send -Rv lxd/containers/$i@$i.snap | gzip > ${SNAPSHOT_DIR}/$i.snap.gz
done

echo "Compression and upload process completed : `date`" >> ${LOGFILE}

echo "Deleting local snapshots taken initially : `date`"  >> ${LOGFILE}

for i in `lxc list | awk '!/NAME/{ if ( $4 == "RUNNING" ) print $2}'`
do
   zfs destroy lxd/containers/$i@$i.snap
done

echo "Local snapshots deleted : `date`"  >> ${LOGFILE}

#Recording End Time
#ENDTIME=$(date +"%T")
end_time="$(date -u +%s)"

#Calculating total time elapsed
#TOTALTIME=$(($ENDTIME - $STARTTIME))
elapsed="$(($end_time-$start_time))"

#Snapshot end notification
echo -e "Snapshot ID : ${SNAPSHOTID} ended at `date` " >> ${LOGFILE}

echo -e "Total time taken for whole snapshot process to complete: $elapsed seconds" >> ${LOGFILE}
