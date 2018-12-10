#!/bin/bash

pushd ./17.11.4
docker build -t local/docker-dpdk:dpdk-17.11.4 ./
popd
