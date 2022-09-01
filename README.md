# Toolchain

[[_TOC_]]

Collect build scripts and docker image creation for TQ ARM Boards in one place.

## Licensing

See file COPYING and license texts under LICENSES.

## Versioning

Semantic versioning will be used for this project.

Given a version number MAJOR.MINOR.PATCH, increment the:

- MAJOR version for new dockerfiles
- MINOR version for functional changes on existing dockerfiles / compose / logic
- PATCH version for bugfixes on existing Dockerfiles (e.g. missing tools)
- NO_INCREMENT for changes on docs, comments, formatting

Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

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
- The changelog is created with [changie](https://changie.dev/guide/installation/)
- A default user is added via docker build args,
  defaults are set in Makefile (name=sysiphos, uid=1010, gid=1010)

## Usage

### Environment

If certificates are needed inside the containers to access git servers etc.
these can be included into the container images by copying the certificate files
to the certificates folder before building.

To work with an own container registry the URL has to be supplied via the environment
(this is necessary only once per shell session):

```bash
$export REGISTRY_BASE_URL=${MY_REGISTRY_BASE_URL}
```

### Default user

The bare, ptxdist and yocto containers define a default user using the ARG statement. In the Makefile, ci_user_name, ci_user_uid, ci_user_gid are set to default values (name=sysiphos, uid=1010, gid=1010). 

Call docker-compose with build-arg to change the default user:

```
--build-arg ci_user_name=<name>
--build-arg ci_user_uid=<uid>
--build-arg ci_user_gid=<gid>
```

When using the Makefile approach set the Environment variables:

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ export CI_USER_NAME=<name>
$ export CI_USER_UID=<uid>
$ export CI_USER_GID=<gid>
$ make all
```

### Build image
Use *docker-compose* to build an image:

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ IMAGE=<service name from docker-compose.yaml>
$ docker-compose build --build-arg registry_base_url=${REGISTRY_BASE_URL} ${IMAGE}
```

The [Default user](#default-user) could be changed for bare, ptxdist and yocto images.

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
# if IMAGE is not set, all services declared in docker-compose.yaml are pulled
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
above mentioned steps and allows (re)building of all images. Again, setting the
REGISTRY_BASE_URL is only needed once per shell session.

### Build all images

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ make all
```

The [Default user](#default-user) could be changed for bare, ptxdist and yocto images.

### Rebuild all images from scratch

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ make new
```

The [Default user](#default-user) could be changed for bare, ptxdist and yocto images.

### Build a single image

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ IMAGE=<service name from docker-compose.yaml>
$ make image IMAGE=${IMAGE}
```

The [Default user](#default-user) could be changed for bare, ptxdist and yocto images.

### Run shell inside container

See [Container for local development](#container-for-local-development)).

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ IMAGE=<service name from docker-compose.yaml> make run
```

### Other commands

The Makefile also provides the targets `push`, `pull`, `update`, `clean`
and `print` that affect all images. Nevertheless, login to the registry is
needed for pushing, pulling and updating the images

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
| ---------------------------------- | -------------------------- | ------------------------------------------------- |
| bare-base-ubuntu-18.04             | bare-base:ubuntu-18.04     | toolchains only (Ubuntu 18.04)                    |
| ---------------------------------- | -------------------------- | ------------------------------------------------- |
| bare-devel-ubuntu-18.04            | bare-devel:ubuntu-18.04    | toolchains only (Ubuntu 18.04), local user        |
| ---------------------------------- | -------------------------- | ------------------------------------------------- |
| bare-ubuntu-18.04                  | bare:ubuntu-18.04          | toolchains only (Ubuntu 18.04), gitlab-ci support |

## Customizing images and containers

To decouple container images as a fixed build environment from sources and build
result, the docker bind mount feature can be used.

### Specifying volumes in docker-compose

Host paths and their mountpoints inside the container can be defined as volumes
on a per service base. Find the desired service in the `docker-compose.yaml`
file and add a `volumes` block:

```diff
 yocto-devel-ubuntu-20.04:
   build:
       context: .
       dockerfile: yocto-devel/Dockerfile.ubuntu-20.04
+  volumes:
+    - ${HOME}/devel:/devel:rw
   image: ${REGISTRY_BASE_URL}/yocto-devel:ubuntu-20.04
   depends_on:
     - yocto-base-ubuntu-20.04
```

A volume is not inherited from a service that is given as dependency. That
means if you specify a volume in a base service (e.g. `yocto-base-ubuntu-20.04`
in the example above), it is not mounted in an service that depends on that
base service.

Many more options are available and documented in
https://docs.docker.com/compose/compose-file.

### Custom docker-compose run command

The options that can be set in the `docker-compose.yaml` file, can also be
passed as options to the `docker-compose` CLI:

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ docker-compose run --volume=${HOME}/devel:/devel <service name from docker-compose.yaml>
```

One can add custom command line arguments for the `docker-compose run`
command to the `run` target in the Makefile via the `RUN_ARGS` env variable.
This way, the `run` target can be used as a shorthand and volumes are mounted
on every container that is started with the `run` target.

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ RUN_ARGS="--volume=${HOME}/devel:/devel
$ IMAGE=<service name from docker-compose.yaml>
$ make run IMAGE=${IMAGE} RUN_ARGS="${RUN_ARGS}"
```

### Container for local development

For ptxdist and yocto a set of templates is supplied, that allow mapping of
user and group ID between host and container. These images have the string
`devel` in their name.

The following example shows, how to use this:

- name is a useful name for the container to be start
- ${HOME}/devel will be mounted as /devel in the container
- user and group ID of calling user will be mapped into the container
- when the container is started, it can be used to build software in the
  devel folder from command line while edit the files at the same time from your
  development host

```bash
$ export REGISTRY_BASE_URL=<registry server/path on server>
$ IMAGE=<service name from docker-compose.yaml>
$ RUN_ARGS="--name <name> --rm -e HOST_USER_ID=$(id -u) -e HOST_USER_GID=$(id -g) --volume ${HOME}/devel:/devel"
$ make run RUN_ARGS="${RUN_ARGS}" IMAGE="${IMAGE}"
# now inside container
$ cd /devel/u-boot
$ export CROSS_COMPILE=<path to gcc>/<gcc base name>
$ export ARCH=[arm|arm64]
$ make <board config>
$ make
```
