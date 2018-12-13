#!/bin/bash

set -x

dpdk_prerequisites() {

echo " \
gcc \
make \
build-essential \
curl \
libnuma1 \
libnuma-dev \
git \
"
}

dpdk_clone() {

	git_clone "${SRC_DIR}" "${DPDK_REPO}" "${DPDK_VERSION}"
}

dpdk_pull() {

	local_SRC_DIR=$1
	local_DPDK_VERSION=$3

	git_pull "${local_SRC_DIR}/dpdk" "${local_DPDK_VERSION}"
}

dpdk_userspace_config() {

	sed -i s/CONFIG_RTE_EAL_IGB_UIO=y/CONFIG_RTE_EAL_IGB_UIO=n/ ${DPDK_DIR}/config/common_linuxapp
	sed -i s/CONFIG_RTE_LIBRTE_KNI=y/CONFIG_RTE_LIBRTE_KNI=n/ ${DPDK_DIR}/config/common_linuxapp
	sed -i s/CONFIG_RTE_KNI_KMOD=y/CONFIG_RTE_KNI_KMOD=n/ ${DPDK_DIR}/config/common_linuxapp
	sed -i s/CONFIG_RTE_LIBRTE_PMD_KNI=y/CONFIG_RTE_LIBRTE_PMD_KNI=n/ ${DPDK_DIR}/config/common_linuxapp

	sed -i s/CONFIG_RTE_APP_TEST=y/CONFIG_RTE_APP_TEST=n/ ${DPDK_DIR}/config/common_linuxapp
	sed -i s/CONFIG_RTE_TEST_PMD=y/CONFIG_RTE_TEST_PMD=n/ ${DPDK_DIR}/config/common_linuxapp
}

dpdk_build() {

	local_DPDK_DIR=$1
	local_DPDK_TARGET=$2

	cd ${local_DPDK_DIR}
	export DPDK_BUILD=$local_DPDK_DIR/$local_DPDK_TARGET
	make install T=${local_DPDK_TARGET} DESTDIR=install -j20
	cd -
}

dpdk_remote_install() {

	local_SRC_DIR=$1
	local_DPDK_REPO=$2
	local_DPDK_VERSION=$3
	local_DPDK_TARGET=$4
	local_SCRIPTS_DIR=$5
	
	local_exec_cmd="\
		source $local_SCRIPTS_DIR/dpdk_utils.sh;\
		dpdk_clone $local_SRC_DIR $local_DPDK_REPO $local_DPDK_VERSION;\
		dpdk_build $local_SRC_DIR/dpdk $local_DPDK_TARGET"
	echo "dpdk_remote_install: ${local_exec_cmd}"
	exec_remote "${local_SRC_DIR}" "${local_exec_cmd}" "${TGT_IP}" "${TGT_USER}" "${TGT_PASS}"
}

set +x

