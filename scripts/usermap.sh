#!/bin/bash

################################################################################
# adjust UID and GID for user $USER
# Container should be started with:
# docker run --name tqma53 --rm -ti -e HOST_USER_ID=$(id -u) -e HOST_USER_GID=$(id -g) \
#     -v ${HOME}/devel:/devel <REGISTRY_BASE_URL>/<container>:<tag>
################################################################################

if [ -z "${USER}" ]; then
    echo "ERROR: container has no USER env!"; exit 100
fi

# if both not set we do not need to do anything
if [ -z "${HOST_USER_ID}" -a -z "${HOST_USER_GID}" ]; then
    echo "INFO: Nothing to do here." ; exit 0
fi

# reset user/gid to either new id or if empty old (still one of above
# might not be set)
USER_ID=${HOST_USER_ID:=$USER_ID}
USER_GID=${HOST_USER_GID:=$USER_GID}

usermod  -u ${USER_ID}  ${USER}
groupmod -g ${USER_GID} ${USER}
usermod  -g ${USER_ID}  ${USER}

su - "${USER}"
