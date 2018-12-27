#!/bin/bash

DPDK_IMG=${1:-local}
DPDK_VERSION=${2:-v17.11-rc4}

docker volume rm $(docker volume ls -qf dangling=true)
#docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
docker rmi $(docker images | grep "none" | awk '/ / { print $3 }')
docker rm $(docker ps -qa --no-trunc --filter "status=exited")

case ${DPDK_IMG} in
	"hub")
	DPDK_IMG=shrewdthingsltd/docker-dpdk:dpdk-$DPDK_VERSION
	docker pull $DPDK_IMG
	;;
	*)
	DPDK_IMG=local/docker-dpdk:dpdk-$DPDK_VERSION
	DPDK_REPO="https://github.com/ShrewdThingsLtd/dpdk.git"
	docker build \
		-t $DPDK_IMG \
		--build-arg IMG_DPDK_REPO=$DPDK_REPO \
		--build-arg IMG_DPDK_VERSION=$DPDK_VERSION \
		./
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
