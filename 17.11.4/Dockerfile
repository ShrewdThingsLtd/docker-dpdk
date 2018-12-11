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

ENV DPDK_DIR=$IMG_DPDK_DIR

COPY dpdk_utils.sh ${IMG_SRC_DIR}/dpdk_utils.sh

WORKDIR $IMG_SRC_DIR
RUN . ${IMG_SRC_DIR}/dpdk_utils.sh && dpdk_clone $IMG_SRC_DIR $IMG_DPDK_REPO $IMG_DPDK_VERSION

# don't build kernel modules
# don't build unnecessary stuff, can be reversed in dpdk_env.sh
RUN . ${IMG_SRC_DIR}/dpdk_utils.sh && dpdk_docker_config $IMG_DPDK_DIR

# set DPDK_TARGET by sourcing dpdk_env.sh, should be in the build dir of the child image
# must be sourced in beginning of any RUN instruction that needs it
ONBUILD COPY dpdk_env.sh ${DPDK_DIR}/
ONBUILD COPY dpdk_config.sh ${DPDK_DIR}/

WORKDIR $IMG_DPDK_DIR
ONBUILD RUN \
	. ${DPDK_DIR}/dpdk_env.sh; \
	. ${DPDK_DIR}/dpdk_config.sh; \
	. $IMG_SRC_DIR/dpdk_utils.sh; \
	dpdk_build $IMG_DPDK_DIR $DPDK_TARGET
#ONBUILD RUN make clean
