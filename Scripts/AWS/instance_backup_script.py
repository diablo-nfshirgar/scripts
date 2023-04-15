# This script automates the backup of EC2 instances in AWS using EBS snapshots.
# It can create snapshots of all attached EBS volumes of an instance, tag the snapshots for easy identification, and set retention policies for automated snapshot cleanup.

import boto3
import datetime

# Initialize AWS clients
ec2 = boto3.client('ec2')

# Define EC2 instance ID
instance_id = '<id>'

# Define snapshot retention period in days
retention_days = 7

# Get current timestamp
timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')

# Get list of attached EBS volumes for the instance
volumes = ec2.describe_volumes(Filters=[{'Name': 'attachment.instance-id', 'Values': [instance_id]}])

# Loop through each volume and create snapshot
for volume in volumes['Volumes']:
    snapshot_name = f'{instance_id}_{volume["VolumeId"]}_{timestamp}'
    snapshot = ec2.create_snapshot(VolumeId=volume['VolumeId'], Description=snapshot_name)
    ec2.create_tags(Resources=[snapshot['SnapshotId']], Tags=[{'Key': 'Name', 'Value': snapshot_name}])
    print(f'Snapshot created: {snapshot["SnapshotId"]}')

# Get snapshots older than retention period
snapshots = ec2.describe_snapshots(Filters=[{'Name': 'description', 'Values': [f'*{instance_id}*']}])
snapshots_to_delete = []
for snapshot in snapshots['Snapshots']:
    if (datetime.datetime.now() - snapshot['StartTime']).days > retention_days:
        snapshots_to_delete.append(snapshot['SnapshotId'])

# Delete snapshots older than retention period
if snapshots_to_delete:
    ec2.delete_snapshots(SnapshotIds=snapshots_to_delete)
    print(f'{len(snapshots_to_delete)} snapshots deleted.')

