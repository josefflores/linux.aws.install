#!/bin/bash

### .aws_metadata.sh
######

# Get Metadata variables except for
#   block-device-mapping/, metrics/, network/, placement/, public-keys/
export URL_METADATA=http://169.254.169.254/latest/meta-data/

export META_AMI_ID=$(curl -s ${URL_METADATA}ami-id)
export META_AMI_LAUNCH_INDEX=$(curl -s ${URL_METADATA}ami-launch-index)
export META_AMI_MANIFEST_PATH=$(curl -s ${URL_METADATA}ami-manifest-path)
export META_HOSTNAME=$(curl -s ${URL_METADATA}hostname)
export META_INSTANCE_ACTION=$(curl -s ${URL_METADATA}instance-action)
export META_INSTANCE_ID=$(curl -s ${URL_METADATA}instance-id)
export META_INSTANCE_TYPE=$(curl -s ${URL_METADATA}instance-type)
export META_LOCAL_HOSTNAME=$(curl -s ${URL_METADATA}local-hostname)
export META_LOCAL_IPV4=$(curl -s ${URL_METADATA}local-ipv4)
export META_MAC=$(curl -s ${URL_METADATA}mac)
export META_PROFILE=$(curl -s ${URL_METADATA}profile)
export META_PUBLIC_HOSTNAME=$(curl -s ${URL_METADATA}public-hostname)
export META_PUBLIC_IPV4=$(curl -s ${URL_METADATA}public-ipv4)
export META_RESERVATION_ID=$(curl -s ${URL_METADATA}reservation-id)
export META_SEC_GROUP=$(curl -s ${URL_METADATA}security-groups)

# Export tags to environment variables
$AWS_TAGS = $(aws ec2 describe-tags --filters Name=resource-id,Values=${META_INSTANCE_ID})
# Get single list of key value pairs
$AWS_TAGS = $($AWS_TAGS | jq '[.Tags[] | "\(.Key)=\(.Value)"] | .[]')
# Strip quotes
$AWS_TAGS = $($AWS_TAGS | sed 's/\"//g')
# Strip extra whitespace characters
$AWS_TAGS = $($AWS_TAGS | sed 's/[:space:]+/ /g')

for prop in $AWS_TAGS
do
    export $prop
done
