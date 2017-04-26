#!/bin/bash

### .aws_metadata.sh
######

# Get Metadata variables except for
#   block-device-mapping/, metrics/, network/, placement/, public-keys/
export URL_METADATA=http://169.254.169.254/latest/meta-data
export META_AMI_ID=${curl ${URL_METADATA}ami-id}
export META_AMI_LAUNCH_INDEX=${curl ${URL_METADATA}ami-launch-index}
export META_AMI_MANIFEST_PATH=${curl ${URL_METADATA}ami-manifest-path}
export META_HOSTNAME=${curl ${URL_METADATA}hostname}
export META_INSTANCE_ACTION=${curl ${URL_METADATA}instance-action}
export META_INSTANCE_ID=${curl ${URL_METADATA}instance-id}
export META_INSTANCE_TYPE=${curl ${URL_METADATA}instance-type}
export META_LOCAL_HOSTNAME=${curl ${URL_METADATA}local-hostname}
export META_LOCAL_IPV4=${curl ${URL_METADATA}local-ipv4}
export META_MAC=${curl ${URL_METADATA}mac}
export META_PROFILE=${curl ${URL_METADATA}profile}
export META_PUBLIC_HOSTNAME=${curl ${URL_METADATA}public-hostname}
export META_PUBLIC_IPV4=${curl ${URL_METADATA}public-ipv4}
export META_RESERVATION_ID=${curl ${URL_METADATA}reservation-id}
export META_SEC_GROUP=${curl ${URL_METADATA}security-groups}

# Export tags to environment variables
AWS_TAGS = aws ec2 describe-tags --filters Name=resource-id,Values=${META_INSTANCE_ID} | jq '[.Tags[] | "\(.Key)=\(.Value)"] | .[]' | $ sed 's/\"//g'
for prop in AWS_TAGS
do
    export ${$prop}
done
