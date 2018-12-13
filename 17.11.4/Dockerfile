
ARG IMG_DPDK_REPO=git://dpdk.org/dpdk
ARG IMG_DPDK_VERSION=v17.11-rc4

FROM ubuntu:latest

ENV SRC_DIR=/usr/src
ENV DPDK_DIR=$SRC_DIR/dpdk
ENV DPDK_REPO=$IMG_DPDK_REPO
ENV DPDK_VERSION=$IMG_DPDK_VERSION

COPY utils/exec_utils.sh ${SRC_DIR}/exec_utils.sh
COPY utils/git_utils.sh ${SRC_DIR}/git_utils.sh
COPY utils/dpdk_utils.sh ${SRC_DIR}/dpdk_utils.sh

RUN exec_apt_install $(dpdk_prerequisites)
#RUN exec_apt_clean

WORKDIR $SRC_DIR
RUN \
	. ${SRC_DIR}/exec_utils.sh; \
	. ${SRC_DIR}/git_utils.sh; \
	. ${SRC_DIR}/dpdk_utils.sh; \
	dpdk_clone; \
	dpdk_userspace_config

# set DPDK_TARGET by sourcing dpdk_env.sh, should be in the build dir of the child image
# must be sourced in beginning of any RUN instruction that needs it
ONBUILD COPY dpdk_env.sh ${DPDK_DIR}/
ONBUILD COPY dpdk_config.sh ${DPDK_DIR}/

WORKDIR $DPDK_DIR
ONBUILD RUN \
	. ${DPDK_DIR}/dpdk_env.sh; \
	. ${DPDK_DIR}/dpdk_config.sh; \
	. ${SRC_DIR}/exec_utils.sh; \
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
	. ${SRC_DIR}/exec_utils.sh; \
	. ${SRC_DIR}/dpdk_utils.sh; \
	dpdk_build $DPDK_DIR $DPDK_TARGET
#ONBUILD RUN make clean
