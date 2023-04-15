#!/bin/bash

# Automate S3 bucket cleanup. This script will assume AWS credentials are already setup using `aws configure` command and user has enough s3 permissions

# User input for bucket name and cleanup criteria
read -p "Enter bucket name: " BUCKET_NAME
read -p "Enter object age (in days): " OBJECT_AGE

# Calculate date cutoff for object age
CUTOFF_DATE=$(date -u -d "-${OBJECT_AGE} days" +%Y-%m-%d)

# List objects in the bucket
OBJECTS=$(aws s3api list-objects \
  --bucket "${BUCKET_NAME}" \
  --query "Contents[?LastModified<='${CUTOFF_DATE}'].Key" \
  --output text)

# Delete objects in the bucket
if [ -n "${OBJECTS}" ]; then
  echo "Deleting objects in ${BUCKET_NAME} that are older than ${OBJECT_AGE} days..."
  aws s3api delete-objects \
    --bucket "${BUCKET_NAME}" \
    --delete "$(aws s3api get-delete-objects-request \
      --bucket "${BUCKET_NAME}" \
      --delete "Objects=[$(printf '{Key=%s},' ${OBJECTS})],Quiet=false")"
  echo "Objects deleted."
else
  echo "No objects found in ${BUCKET_NAME} that are older than ${OBJECT_AGE} days."
fi

