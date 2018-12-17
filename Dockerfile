
FROM ubuntu:latest

ARG IMG_DPDK_REPO="https://github.com/ShrewdThingsLtd/dpdk.git"
ARG IMG_DPDK_VERSION="v17.11-rc4"

ENV DPDK_REPO="${IMG_DPDK_REPO}"
ENV DPDK_VERSION=$IMG_DPDK_VERSION
ENV SRC_DIR=/usr/src
ENV DPDK_DIR=$SRC_DIR/dpdk

COPY utils/*.sh ${SRC_DIR}/utils/
COPY env/*.sh ${SRC_DIR}/env/
COPY app-entrypoint.sh ${SRC_DIR}/

RUN . ${SRC_DIR}/app-entrypoint.sh; \
	exec_apt_update

RUN . ${SRC_DIR}/app-entrypoint.sh; \
	exec_apt_install "$(dpdk_prerequisites)"
#RUN exec_apt_clean

RUN . ${SRC_DIR}/app-entrypoint.sh; \
	dpdk_clone; \
	dpdk_userspace_config

WORKDIR $DPDK_DIR
ONBUILD COPY utils/*.sh ${SRC_DIR}/utils/
ONBUILD COPY env/*.sh ${SRC_DIR}/env/

ONBUILD RUN . ${SRC_DIR}/app-entrypoint.sh; \
	app_dpdk_configure; \
	dpdk_build; \
	dpdk_remote_install
#ONBUILD RUN make clean
