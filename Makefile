################################################################################
# SPDX-License-Identifier: MIT
# Copyright (c) 2021-2023 TQ-Systems GmbH <oss@ew.tq-group.com>
# author: Martin Schmiedel
################################################################################

# per default this is the docker bridge device
# not needed anymore, hopefully
# PROXY ?= http://172.17.0.1:3128
PROXY ?= ""

# container registry for tq-modules
REGISTRY_BASE_URL ?= ${REGISTRY_BASE_URL}

# user name and id's for build user
CI_USER_NAME ?= sysiphos
CI_USER_UID ?= 1010
CI_USER_GID ?= 1010

# used java version in container
CI_JAVA_VERSION ?= openjdk-11-jre

# used gitlab cli version in container
CI_GLAB_VERSION ?= 1.36.0

# When needed to add the defined variables to BUILD_ARGS:
# --build-arg http_proxy=${PROXY} --build-arg https_proxy=${PROXY}
BUILD_ARGS = \
	--build-arg registry_base_url=${REGISTRY_BASE_URL} \
	--build-arg ci_user_name=${CI_USER_NAME} \
	--build-arg ci_user_uid=${CI_USER_UID} \
	--build-arg ci_user_gid=${CI_USER_GID} \
	--build-arg ci_java_version=${CI_JAVA_VERSION} \
	--build-arg ci_glab_version=${CI_GLAB_VERSION}

RUN_ARGS ?= --rm

IMAGE ?= bare-devel-ubuntu-18.04

DISTRO = ubuntu
DISTRO_VERSIONS = 14.04 16.04 18.04 20.04
BASE_IMAGES = $(addprefix base-${DISTRO}-,${DISTRO_VERSIONS})

PTX_VERSIONS = 14.04 18.04
PTX_BASE_IMAGES = $(addprefix ptxdist-base-${DISTRO}-,${PTX_VERSIONS})
PTX_DEVEL_IMAGES = $(addprefix ptxdist-devel-${DISTRO}-,${PTX_VERSIONS})
PTX_IMAGES = $(addprefix ptxdist-${DISTRO}-,${PTX_VERSIONS})

YOCTO_VERSIONS = 16.04 18.04 20.04
YOCTO_BASE_IMAGES = $(addprefix yocto-base-${DISTRO}-,${YOCTO_VERSIONS})
YOCTO_DEVEL_IMAGES = $(addprefix yocto-devel-${DISTRO}-,${YOCTO_VERSIONS})
YOCTO_IMAGES = $(addprefix yocto-${DISTRO}-,${YOCTO_VERSIONS})

BARE_VERSIONS = 18.04
BARE_BASE_IMAGES = $(addprefix bare-base-${DISTRO}-,${BARE_VERSIONS})
BARE_DEVEL_IMAGES = $(addprefix bare-devel-${DISTRO}-,${BARE_VERSIONS})
BARE_IMAGES = $(addprefix bare-${DISTRO}-,${BARE_VERSIONS})

ALL_IMAGES = \
	${BASE_IMAGES} \
	${PTX_BASE_IMAGES} \
	${PTX_DEVEL_IMAGES} \
	${PTX_IMAGES} \
	${YOCTO_BASE_IMAGES} \
	${YOCTO_DEVEL_IMAGES} \
	${YOCTO_IMAGES} \
	${BARE_BASE_IMAGES} \
	${BARE_DEVEL_IMAGES} \
	${BARE_IMAGES}

all:
	export REGISTRY_BASE_URL=${REGISTRY_BASE_URL} && docker-compose build ${BUILD_ARGS} ${ALL_IMAGES}

new:
	export REGISTRY_BASE_URL=${REGISTRY_BASE_URL} && docker-compose build --no-cache --force-rm ${BUILD_ARGS} ${ALL_IMAGES}

image:
	export REGISTRY_BASE_URL=${REGISTRY_BASE_URL} && docker-compose build ${BUILD_ARGS} ${IMAGE}

# Example from README.md with custom options devel templates:
# export RUN_ARGS="--rm -e HOST_USER_ID=$(id -u) -e HOST_USER_GID=$(id -g) --volume ${HOME}/devel:/devel"
# docker-compose run ${RUN_ARGS} ${IMAGE}
run:
	export REGISTRY_BASE_URL=${REGISTRY_BASE_URL} && \
	docker-compose run ${RUN_ARGS} ${IMAGE}

push:
	export REGISTRY_BASE_URL=${REGISTRY_BASE_URL} && docker-compose push

pull:
	export REGISTRY_BASE_URL=${REGISTRY_BASE_URL} && docker-compose pull

clean:
	docker system prune -f

update: pull clean

print:
	@echo "BASE:	${BASE_IMAGES}"
	@echo "PTX:	${PTX_BASE_IMAGES} ${PTX_IMAGES} ${PTX_DEVEL_IMAGES}"
	@echo "YOCTO:	${YOCTO_BASE_IMAGES} ${YOCTO_IMAGES} ${YOCTO_DEVEL_IMAGES}"
	@echo "BARE:	${BARE_BASE_IMAGES} ${BARE_IMAGES} ${BARE_DEVEL_IMAGES}"

.PHONY: all new image run push pull print clean update
