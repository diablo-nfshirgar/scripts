# Openstack scripts
Scripts used to perform specific openstack related activities that are not part of Chef or daily routine


## volume_cleanup.sh
Description: This script is used for automating stale or un-used volumes clean-up from Openstack:

- Pre-requisites:
  - It is ideal to deploy openstack related customs (such as scripts, script logs etc..) inside `/opt/openstack` folder. Please keep this script inside `/opt/openstack/scripts` folder.
  - Also, it is a MUST to copy the OpenRC script (named as `admin-openrc.sh` which also MUST include openstack `admin` user's password as mentioned below) inside `/opt/openstack/scripts` folder in order for script to be able to execute openstack operational commands during the run:
`export OS_PASSWORD=<password>`
  - The script MUST NOT be executed by user other than root

- What does script actually do ?
  - The script will basically do the following:
    1. Check the volume state. If its in either of the following state, skip the volume from deleting it:
    `in-use`
    `reserved`
    `backing-up`
    `extending`
    (We found volumes in these state to be kept intact on the openstack since typically we don't remove volumes which are in these state and in case if in the future we want to preserve any volumes from being removed, we can switch them to any of these state)

    2. If the volume is not in any of the above mentioned state, proceed with the deletion.

    3. Also chek those volumes which aren't in available state. If there are, change those volumes state to `available`

    4. Once state is changed to available, delete the volume.

- How to test the script ?
  - Login to Openstack controller node dashboard and create multiple volumes (These will be marked as `available`)
  - Change the status of few of those newly created volumes to any of the following state:
    `creating`
    `deleting`
    `error`
    Basically, volumes with these state along with `available` should be removed post script execution.
  - Run the script that will remove those volumes
  - Verify if volumes are removed successfully
