#!/usr/bin/env python3

# This simple script automates the backup of critical data or configurations, such as database backups, configuration files, or system snapshots. It can be scheduled to run periodically and can leverage AWS S3 or other storage solutions for secure and reliable backups.

import shutil
import datetime

# Source and destination paths
source_dir = '<src_path>'
destination_dir = '<dest_path>'

# Generate backup file name with timestamp
timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
backup_file = f'backup_{timestamp}.tar.gz'

# Create a tarball of the source directory
shutil.make_archive(backup_file, 'gztar', source_dir)

# Move the backup file to the destination directory
shutil.move(backup_file, destination_dir)

print(f'Backup created: {destination_dir}/{backup_file}')

