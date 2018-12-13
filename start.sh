#!/bin/bash

DPDK_IMG=${1:-local}
DPDK_VERSION=${2:-v17.11-rc4}
TGT_IP=${3:-172.17.0.1}
TGT_USER=${4:-root}
TGT_PASS=${5:-devops123}

if [ ! -d "./$DPDK_VERSION" ]
then
	echo "unsupported DPDK_VERSION: $DPDK_VERSION"
	exit -1
fi

case ${DPDK_IMG} in
	"hub")
	DPDK_IMG=shrewdthingsltd/docker-dpdk:dpdk-$DPDK_VERSION
	docker pull $DPDK_IMG
	;;
	*)
	DPDK_IMG=local/docker-dpdk:dpdk-$DPDK_VERSION
	DPDK_REPO="https://github.com/ShrewdThingsLtd/dpdk.git"
	rm -rf ./$DPDK_VERSION/utils
	cp -r ./utils ./$DPDK_VERSION
	cd ./$DPDK_VERSION
	docker build \
		-t $DPDK_IMG \
		--build-arg IMG_DPDK_REPO=$DPDK_REPO \
		--build-arg IMG_DPDK_VERSION=$DPDK_VERSION \
		--build-arg IMG_TGT_IP=$TGT_IP \
		--build-arg IMG_TGT_USER=$TGT_USER \
		--build-arg IMG_TGT_PASS=$TGT_PASS \
		./
	cd -
	rm -rf ./$DPDK_VERSION/utils
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
