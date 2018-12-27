#!/bin/bash

dpdk_igb_uio_install() {

	sleep 1
	rmmod igb_uio
	sleep 1
	modprobe uio
	sleep 1
	insmod "${DPDK_DIR}/${DPDK_TARGET}/kmod/igb_uio.ko"
}
