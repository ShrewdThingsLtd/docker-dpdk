#!/bin/bash

set -x

dpdk_prerequisites() {

	echo 'gcc make git curl build-essential libnuma1 libnuma-dev ssh sshpass'
}

dpdk_clone() {

	git_clone $SRC_DIR $DPDK_REPO $DPDK_VERSION
}

dpdk_pull() {

	git_pull "${DPDK_DIR}" "${DPDK_VERSION}"
}

dpdk_kni_disable() {

	sed -i s/CONFIG_RTE_LIBRTE_KNI=y/CONFIG_RTE_LIBRTE_KNI=n/ ${DPDK_DIR}/config/common_linuxapp
	sed -i s/CONFIG_RTE_KNI_KMOD=y/CONFIG_RTE_KNI_KMOD=n/ ${DPDK_DIR}/config/common_linuxapp
	sed -i s/CONFIG_RTE_LIBRTE_PMD_KNI=y/CONFIG_RTE_LIBRTE_PMD_KNI=n/ ${DPDK_DIR}/config/common_linuxapp
}

dpdk_igb_uio_disable() {

	sed -i s/CONFIG_RTE_EAL_IGB_UIO=y/CONFIG_RTE_EAL_IGB_UIO=n/ ${DPDK_DIR}/config/common_linuxapp
}

dpdk_userspace_config() {

	dpdk_kni_disable
	dpdk_igb_uio_disable
	sed -i s/CONFIG_RTE_APP_TEST=y/CONFIG_RTE_APP_TEST=n/ ${DPDK_DIR}/config/common_linuxapp
	sed -i s/CONFIG_RTE_TEST_PMD=y/CONFIG_RTE_TEST_PMD=n/ ${DPDK_DIR}/config/common_linuxapp
}

set +x

