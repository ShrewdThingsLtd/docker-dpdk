
FROM ubuntu:latest

ARG IMG_DPDK_REPO="https://github.com/ShrewdThingsLtd/dpdk.git"
ARG IMG_DPDK_VERSION="v17.11-rc4"

ENV DPDK_REPO="${IMG_DPDK_REPO}"
ENV DPDK_VERSION=$IMG_DPDK_VERSION
ENV SRC_DIR=/usr/src
ENV DPDK_DIR=$SRC_DIR/dpdk

COPY app/env/*.sh ${SRC_DIR}/env/
COPY app/utils/*.sh ${SRC_DIR}/utils/
COPY app/entrypoint/*.sh ${SRC_DIR}/
ENV BASH_ENV=${SRC_DIR}/app-entrypoint.sh
SHELL ["/bin/bash", "-c"]

RUN exec_apt_update
RUN exec_apt_install "$(dpdk_prerequisites)"
#RUN exec_apt_clean

RUN \
	dpdk_clone; \
	dpdk_userspace_config

COPY app/runtime/*.sh ${SRC_DIR}/runtime/

WORKDIR $DPDK_DIR
ONBUILD COPY app/env/*.sh ${SRC_DIR}/env/
ONBUILD COPY app/utils/*.sh ${SRC_DIR}/utils/
ONBUILD COPY app/entrypoint/*.sh ${SRC_DIR}/

ONBUILD RUN \
	dpdk_configure; \
	dpdk_build; \
	dpdk_remote_install
#ONBUILD RUN make clean
