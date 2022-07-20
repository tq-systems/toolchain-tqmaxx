# Toolchain

[[_TOC_]]

Collect build scripts and docker image creation for TQ ARM Boards in one place.

## Licensing

See file COPYING and license texts under LICENSES.

## Prerequisites

The documentation herein is written and tested using Ubuntu 18.04 / 20.04, but
should work for every modern debian based distro that has a newer version of
docker.

```bash
$ apt install docker docker-compose
```

The following things are used in this repo and throughout this README:

- This git repo contains multiple docker image definitions for CI and for
  usage on a development workstation
- Access to a docker registry for the docker images. To abstract this the
  `${REGISTRY_BASE_URL}`variable is used
- Usage of a `docker-compose.yaml` file and the `docker-compose` tool to declare
  dependencies between docker images (called services in docker-compose)

## Usage

### Environment

If certificates are needed inside the containers to access git servers etc.
these can be included into the container images by copying the certificate files
to the certificates folder before building.

To work with an own container registry the URL has to be supplied via the environment:

```bash
$export REGISTRY_BASE_URL=${MY_REGISTRY_BASE_URL}
```

### Build image
Use *docker-compose* to build an image:

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ IMAGE=<service name from docker-compose.yaml>
$ docker-compose build --build-arg registry_base_url=${REGISTRY_BASE_URL} ${IMAGE}
```

### Deploy images

Push image(s) to the configured registry:

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
# if IMAGE is not set, all services declared in docker-compose.yaml are pushed
$ IMAGE=<service name from docker-compose.yaml>
$ docker login -u <user> ${REGISTRY_BASE_URL}
$ docker-compose push ${IMAGE}
$ docker logout
```

### Get images

Pull image(s) from the configured registry:

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
# if IMAGE is not set, all services declared in docker-compose.yaml are pushed
$ IMAGE=<service name from docker-compose.yaml>
$ docker login -u <user> ${REGISTRY_BASE_URL}
$ docker-compose pull ${IMAGE}
$ docker logout
```

### Clean local stored images

```bash
$docker system prune -f
```

### Run shell inside container

You must pull or build an image before running it. For running
containers with development images, see [Container for local
development](#container-for-local-development).

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ IMAGE=<service name from docker-compose.yaml>
$ docker-compose run --rm ${IMAGE}
```

### Rebuild image from scratch

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ IMAGE=<service name from docker-compose.yaml>
$ docker-compose build --build-arg registry_base_url=${REGISTRY_BASE_URL} --no-cache --force-rm ${IMAGE}
```

## Makefile support

For maintenance and development a simple Makefile is provided, that wraps the
above mentioned steps and allows (re)building of all images.

## Supported images

| Service name (docker-compose.yaml) | Image and tag              | purpose    |
| :--------------------------------: | :------------------------: | :-----------------------------------------------: |
| base-ubuntu-14.04                  | base:ubuntu-14.04          | base image for Ubuntu 14.04, certificates, locale |
| base-ubuntu-16.04                  | base:ubuntu-16.04          | base image for Ubuntu 16.04, certificates, locale |
| base-ubuntu-18.04                  | base:ubuntu-18.04          | base image for Ubuntu 18.04, certificates, locale |
| base-ubuntu-20.04                  | base:ubuntu-20.04          | base image for Ubuntu 20.04, certificates, locale |
| ---------------------------------- | -------------------------- | ------------------------------------------------- |
| ptxdist-base-ubuntu-14.04          | ptxdist-base:ubuntu-14.04  | ptxdist support for Ubuntu 14.04, toolchains      |
| ptxdist-base-ubuntu-18.04          | ptxdist-base:ubuntu-18.04  | ptxdist support for Ubuntu 18.04, toolchains      |
| ---------------------------------- | -------------------------- | ------------------------------------------------- |
| ptxdist-devel-ubuntu-14.04         | ptxdist-devel:ubuntu-14.04 | ptxdist support for Ubuntu 14.04, local user      |
| ptxdist-devel-ubuntu-18.04         | ptxdist-devel:ubuntu-18.04 | ptxdist support for Ubuntu 18.04, local user      |
| ---------------------------------- | -------------------------- | ------------------------------------------------- |
| ptxdist-ubuntu-14.04               | ptxdist:ubuntu-14.04       | ptxdist support for Ubuntu 14.04, jenkins support |
| ptxdist-ubuntu-18.04               | ptxdist:ubuntu-18.04       | ptxdist support for Ubuntu 18.04, jenkins support |
| ---------------------------------- | -------------------------- | ------------------------------------------------- |
| yocto-base-ubuntu-16.04            | yocto-base:ubuntu-14.04    | yocto support for Ubuntu 14.04, tools             |
| yocto-base-ubuntu-18.04            | yocto-base:ubuntu-16.04    | yocto support for Ubuntu 16.04, tools             |
| yocto-base-ubuntu-20.04            | yocto-base:ubuntu-20.04    | yocto support for Ubuntu 20.04, tools             |
| ---------------------------------- | -------------------------- | ------------------------------------------------- |
| yocto-devel-ubuntu-16.04           | yocto-devel:ubuntu-14.04   | yocto support for Ubuntu 14.04, local user        |
| yocto-devel-ubuntu-18.04           | yocto-devel:ubuntu-16.04   | yocto support for Ubuntu 16.04, local user        |
| yocto-devel-ubuntu-20.04           | yocto-devel:ubuntu-20.04   | yocto support for Ubuntu 20.04, local user        |
| ---------------------------------- | -------------------------- | ------------------------------------------------- |
| yocto-ubuntu-16.04                 | yocto:ubuntu-14.04         | yocto support for Ubuntu 14.04, jenkins support   |
| yocto-ubuntu-18.04                 | yocto:ubuntu-16.04         | yocto support for Ubuntu 16.04, jenkins support   |
| yocto-ubuntu-20.04                 | yocto:ubuntu-20.04         | yocto support for Ubuntu 20.04, jenkins support   |

## Container for local development

To decouple container images as a fixed build environment from sources and build
result, the docker bind mount feature can be used. For ptxdist and yocto a set
of templates is supplied, that allow mapping of user and group ID between host
and container. These images have the string `devel` in their name.

The following example shows, how to use this:

- name is a useful name for the container to be start
- ${HOME}/devel will be mounted as /devel in the container
- user and group ID of calling user will be mapped into the container
- when the container is started, it can be used to build software in the
  devel folder from command line while edit the files at the same time from your
  development host

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ IMAGE=<service name from docker-comose.yaml>
$ docker-compose run --name <name> --rm -e HOST_USER_ID=$(id -u) -e HOST_USER_GID=$(id -g) -v ${HOME}/devel:/devel ${IMAGE}
# now inside container
$ cd /devel/u-boot
$ export CROSS_COMPILE=<path to gcc>/<gcc base name>
$ export ARCH=[arm|arm64]
$ make <board config>
$ make
```
