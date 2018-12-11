FROM ubuntu:latest

ARG IMG_SRC_DIR=/usr/src
ARG IMG_DPDK_PFX=dpdk-stable
ARG IMG_DPDK_VERSION=v17.11-rc4
#ARG IMG_DPDK_REPO=git://dpdk.org/dpdk
ARG IMG_DPDK_REPO=https://github.com/ShrewdThingsLtd/dpdk.git

RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc \
  make \
  build-essential \
  curl \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y libnuma1 libnuma-dev git

ENV DPDK_DIR=$IMG_SRC_DIR/dpdk

WORKDIR $IMG_SRC_DIR
RUN git clone $IMG_DPDK_REPO -b $IMG_DPDK_VERSION

# don't build kernel modules
RUN sed -i s/CONFIG_RTE_EAL_IGB_UIO=y/CONFIG_RTE_EAL_IGB_UIO=n/ ${DPDK_DIR}/config/common_linuxapp \
 && sed -i s/CONFIG_RTE_LIBRTE_KNI=y/CONFIG_RTE_LIBRTE_KNI=n/ ${DPDK_DIR}/config/common_linuxapp \
 && sed -i s/CONFIG_RTE_KNI_KMOD=y/CONFIG_RTE_KNI_KMOD=n/ ${DPDK_DIR}/config/common_linuxapp \
 && sed -i s/CONFIG_RTE_LIBRTE_PMD_KNI=y/CONFIG_RTE_LIBRTE_PMD_KNI=n/ ${DPDK_DIR}/config/common_linuxapp

# don't build unnecessary stuff, can be reversed in dpdk_env.sh
RUN sed -i s/CONFIG_RTE_APP_TEST=y/CONFIG_RTE_APP_TEST=n/ ${DPDK_DIR}/config/common_linuxapp \
 && sed -i s/CONFIG_RTE_TEST_PMD=y/CONFIG_RTE_TEST_PMD=n/ ${DPDK_DIR}/config/common_linuxapp

# set DPDK_TARGET by sourcing dpdk_env.sh, should be in the build dir of the child image
# must be sourced in beginning of any RUN instruction that needs it
ONBUILD COPY dpdk_env.sh ${DPDK_DIR}/
ONBUILD COPY dpdk_config.sh ${DPDK_DIR}/

WORKDIR $DPDK_DIR
ONBUILD RUN \
	. ${DPDK_DIR}/dpdk_env.sh; \
	. ${DPDK_DIR}/dpdk_config.sh; \
	make install T=${DPDK_TARGET} DESTDIR=install -j20
#ONBUILD RUN make clean
