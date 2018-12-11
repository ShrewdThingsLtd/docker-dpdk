#!/bin/bash

DPDK_IMG=${1:-local}


case ${DPDK_IMG} in
        "hub")
        DPDK_IMG=shrewdthingsltd/docker-dpdk:dpdk-17.11.4
        docker pull $OVS_IMG
        ;;
        *)
        ./2.10.1/build_ovs.sh
        OVS_IMG=local/docker-dpdk:dpdk-17.11.4
        ;;
esac

docker run -ti --net=host --privileged -v /mnt/huge:/mnt/huge --device=/dev/uio0:/dev/uio0 $DPDK_IMG /bin/bash

