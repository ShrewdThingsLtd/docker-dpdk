#!/bin/bash

for env_file in $(ls -tr ${SRC_DIR}/env/)
do
	. ${SRC_DIR}/env/${env_file}
done

for utils_file in $(ls -tr ${SRC_DIR}/utils/)
do
	. ${SRC_DIR}/utils/${utils_file}
done
