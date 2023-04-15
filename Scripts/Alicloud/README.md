# Alicloud Security Group Rules retrieval script
Script used to list out all existing security groups rules & ports associated with each of those rules in Alicloud


- Pre-requisites:
  - This script expect to have `aliyun` CLI installed on the machine before its execution. Following link may help on how to install it
    - https://www.alibabacloud.com/help/en/alibaba-cloud-cli
  - In addition, this script also expect you to have your Alicloud credentials configured on the machine. Use following command to configure the same post installation of CLI (Best to have `Access Key Id` & `Access Key Secret` in hand before running it.
    - `aliyun configure`

- What does script actually do ?
  - The script will basically do the following:
    1. It will refer to the regions defined in the script

    2. For each region, it will refer to each VPCs configured

    3. It will then iterate through each of the security groups in each particular region

    4. Finally, it will get list of `SourceCidrIp` and `PortRange` from each of those security groups and will publish them in the log file

- How to implement the script ?
  - Configure the credentials
  - Copy / clone the script locally on machine
  - Execute the script to populate the information
  - View the rules inside the log files

- What if i need to get the list of security groups rules from the different region ?
  - At the time of creation of the script, there are mainly two regions configured & used in Alicloud: `eu-central-1` & `ap-southeast-1`
  - In case if you need to get the list of security groups rules from regions other than these, just add the region inside the script in `Region_ID` variable. You may refer the following link to get the region ID for any specific region:
    - https://www.alibabacloud.com/help/en/basics-for-beginners/latest/regions-and-zones#concept-nwo-3ho-q3v

