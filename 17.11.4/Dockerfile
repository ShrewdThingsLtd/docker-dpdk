FROM ubuntu:latest

ARG IMG_SRC_DIR=/usr/src
ARG IMG_DPDK_DIR=$IMG_SRC_DIR/dpdk
#ARG IMG_DPDK_REPO=git://dpdk.org/dpdk
ARG IMG_DPDK_REPO=https://github.com/ShrewdThingsLtd/dpdk.git
ARG IMG_DPDK_VERSION=v17.11-rc4

RUN apt-get update && apt-get install -y apt-utils
RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc \
  make \
  build-essential \
  curl \
  libnuma1 \
  libnuma-dev \
  git
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV SRC_DIR=$IMG_SRC_DIR
ENV DPDK_REPO=$IMG_DPDK_REPO
ENV DPDK_VERSION=$IMG_DPDK_VERSION
ENV DPDK_DIR=$IMG_DPDK_DIR

COPY exec_utils.sh ${IMG_SRC_DIR}/exec_utils.sh
COPY dpdk_utils.sh ${IMG_SRC_DIR}/dpdk_utils.sh

WORKDIR $IMG_SRC_DIR
RUN . ${SRC_DIR}/dpdk_utils.sh; \
	dpdk_clone $SRC_DIR $DPDK_REPO $DPDK_VERSION; \
	dpdk_docker_config $DPDK_DIR

# set DPDK_TARGET by sourcing dpdk_env.sh, should be in the build dir of the child image
# must be sourced in beginning of any RUN instruction that needs it
ONBUILD COPY dpdk_env.sh ${DPDK_DIR}/
ONBUILD COPY dpdk_config.sh ${DPDK_DIR}/

WORKDIR $IMG_DPDK_DIR
ONBUILD RUN \
	. ${DPDK_DIR}/dpdk_env.sh; \
	. ${DPDK_DIR}/dpdk_config.sh; \
	. ${SRC_DIR}/dpdk_utils.sh; \
	dpdk_remote_install \
		/tmp \
		$DPDK_REPO \
		$DPDK_VERSION \
		$DPDK_TARGET \
		/root/GITHUB/ST/docker-dpdk/17.11.4
ONBUILD RUN \
	. ${DPDK_DIR}/dpdk_env.sh; \
	. ${DPDK_DIR}/dpdk_config.sh; \
	. ${SRC_DIR}/dpdk_utils.sh; \
	dpdk_build $DPDK_DIR $DPDK_TARGET
#ONBUILD RUN make clean
