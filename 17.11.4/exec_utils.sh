#!/bin/bash

exec_remote() {

	local remote_dir=$1
	local remote_cmd=$2
	local remote_ip=$3
	local remote_user=$4
	local remote_pass=$5
	local timestamp=$(date +"%Y.%m.%d %H:%M:%S")

	local exec_cmd="cd ${remote_dir}; ${remote_cmd}"
	echo "$(sshpass -p ${remote_pass} ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${remote_user}@${remote_ip} eval '${exec_cmd}')"
}

exec_tgt() {

	local remote_dir=$1
	local remote_cmd=$2

	echo $(exec_remote "${remote_dir}" "${remote_cmd}" "${TGT_IP}" "${TGT_USER}" "${TGT_PASS}")
}

