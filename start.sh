#!/bin/bash

DPDK_IMG=${1:-local}


case ${DPDK_IMG} in
	"hub")
	DPDK_IMG=shrewdthingsltd/docker-dpdk:dpdk-17.11.4
	docker pull $DPDK_IMG
	;;
	*)
	DPDK_IMG=local/docker-dpdk:dpdk-17.11.4
	cd ./17.11.4
	docker build \
		-t $DPDK_IMG \
		./
	cd -
	;;
esac

docker run \
	-ti \
	--net=host \
	--privileged \
	-v /mnt/huge:/mnt/huge \
	--device=/dev/uio0:/dev/uio0 \
	$DPDK_IMG \
	/bin/bash
