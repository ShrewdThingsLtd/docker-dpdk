
FROM ubuntu:latest

ARG IMG_DPDK_REPO
ARG IMG_DPDK_VERSION

ENV DPDK_REPO="${IMG_DPDK_REPO}"
ENV DPDK_VERSION=$IMG_DPDK_VERSION
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

WORKDIR $DPDK_DIR
ONBUILD COPY utils/*.sh ${SRC_DIR}/utils/
ONBUILD COPY app_env.sh ${SRC_DIR}/
ONBUILD COPY app_config.sh ${SRC_DIR}/
ONBUILD RUN \
	. ${SRC_DIR}/utils/exec_utils.sh; \
	. ${SRC_DIR}/utils/dpdk_utils.sh; \
	. ${SRC_DIR}/app_config.sh; \
	dpdk_build
ONBUILD RUN \
	. ${SRC_DIR}/utils/exec_utils.sh; \
	. ${SRC_DIR}/utils/git_utils.sh; \
	. ${SRC_DIR}/utils/dpdk_utils.sh; \
	. ${SRC_DIR}/app_env.sh; \
	dpdk_remote_install
#ONBUILD RUN make clean
