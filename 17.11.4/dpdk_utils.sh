#!/bin/bash

set -x

. ${SRC_DIR}/exec_utils.sh

dpdk_clone() {

	local SRC_DIR=$1
	local DPDK_REPO=$2
	local DPDK_VERSION=$3

	cd $SRC_DIR
	git config --global http.sslVerify false
	git clone "${DPDK_REPO}"
	git config --global http.sslVerify true
	cd -
	cd $SRC_DIR/dpdk
	git checkout "${DPDK_VERSION}"
	cd -
}

dpdk_docker_config() {

	local DPDK_DIR=$1

	sed -i s/CONFIG_RTE_EAL_IGB_UIO=y/CONFIG_RTE_EAL_IGB_UIO=n/ ${DPDK_DIR}/config/common_linuxapp
	sed -i s/CONFIG_RTE_LIBRTE_KNI=y/CONFIG_RTE_LIBRTE_KNI=n/ ${DPDK_DIR}/config/common_linuxapp
	sed -i s/CONFIG_RTE_KNI_KMOD=y/CONFIG_RTE_KNI_KMOD=n/ ${DPDK_DIR}/config/common_linuxapp
	sed -i s/CONFIG_RTE_LIBRTE_PMD_KNI=y/CONFIG_RTE_LIBRTE_PMD_KNI=n/ ${DPDK_DIR}/config/common_linuxapp

	sed -i s/CONFIG_RTE_APP_TEST=y/CONFIG_RTE_APP_TEST=n/ ${DPDK_DIR}/config/common_linuxapp
	sed -i s/CONFIG_RTE_TEST_PMD=y/CONFIG_RTE_TEST_PMD=n/ ${DPDK_DIR}/config/common_linuxapp
}

dpdk_build() {

	local DPDK_DIR=$1
	local DPDK_TARGET=$2

	cd ${DPDK_DIR}
	export DPDK_BUILD=$DPDK_DIR/$DPDK_TARGET
	make install T=${DPDK_TARGET} DESTDIR=install -j20
	cd -
}

dpdk_remote_install() {

	local SRC_DIR=$1
	local DPDK_REPO=$2
	local DPDK_VERSION=$3
	local DPDK_TARGET=$4
	local SCRIPTS_DIR=$5
	
	local exec_cmd="\
		source $SCRIPTS_DIR/dpdk_utils.sh;\
		dpdk_clone $SRC_DIR $DPDK_REPO $DPDK_VERSION;\
		dpdk_build $SRC_DIR/dpdk $DPDK_TARGET"
	echo "dpdk_remote_install: ${exec_cmd}"
	exec_remote "${SRC_DIR}" "${exec_cmd}" "${TGT_IP}" "${TGT_USER}" "${TGT_PASS}"
}

set +x

