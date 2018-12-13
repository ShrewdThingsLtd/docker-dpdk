
FROM ubuntu:latest

ARG IMG_DPDK_REPO
ARG IMG_DPDK_VERSION

ENV DPDK_REPO="${IMG_DPDK_REPO}"
ENV DPDK_VERSION=$IMG_DPDK_VERSION
ENV TGT_UTILS_DIR=/root/GITHUB/ST/docker-dpdk/$DPDK_VERSION/utils
ENV SRC_DIR=/usr/src
ENV DPDK_DIR=$SRC_DIR/dpdk

COPY utils/*.sh ${SRC_DIR}/utils/

RUN \
	. ${SRC_DIR}/utils/exec_utils.sh; \
	exec_apt_update

RUN \
	. ${SRC_DIR}/utils/exec_utils.sh; \
	. ${SRC_DIR}/utils/git_utils.sh; \
	. ${SRC_DIR}/utils/dpdk_utils.sh; \
	exec_apt_install "$(dpdk_prerequisites)"
#RUN exec_apt_clean

RUN \
	. ${SRC_DIR}/utils/exec_utils.sh; \
	. ${SRC_DIR}/utils/git_utils.sh; \
	. ${SRC_DIR}/utils/dpdk_utils.sh; \
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
	. ${SRC_DIR}/utils/exec_utils.sh; \
	. ${SRC_DIR}/utils/git_utils.sh; \
	. ${SRC_DIR}/utils/dpdk_utils.sh; \
	dpdk_remote_install
ONBUILD RUN \
	. ${DPDK_DIR}/dpdk_env.sh; \
	. ${DPDK_DIR}/dpdk_config.sh; \
	. ${SRC_DIR}/utils/exec_utils.sh; \
	. ${SRC_DIR}/utils/dpdk_utils.sh; \
	dpdk_build
#ONBUILD RUN make clean
