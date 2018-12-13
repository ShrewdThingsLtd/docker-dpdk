#!/bin/bash

set -x

exec_log() {

	local_log_file="/tmp/img_log.log"
	local_timestamp=$(date +"%Y.%m.%d %H:%M:%S")
	
	echo "${local_timestamp} ---" >> local_log_file
	echo "$@" >> local_log_file
	eval "$@" >> local_log_file
	echo "---" >> local_log_file
}

exec_apt_install() {

	apt-get -y update && apt-get install -y apt-utils
	exec_log "apt-get install -y --no-install-recommends $@"
}

exec_apt_clean() {

	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
}

exec_yum_install() {

	yum -y update
	exec_log "yum install -y $@"
}

exec_remote() {

	local remote_dir=$1
	local remote_cmd=$2
	local remote_ip=$3
	local remote_user=$4
	local remote_pass=$5

	local exec_cmd="cd ${remote_dir}; ${remote_cmd}"
	local ssh_cmd="sshpass -p ${remote_pass} ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${remote_user}@${remote_ip} /bin/bash -c '${exec_cmd}'"
	echo "${ssh_cmd}"
	echo "$(ssh_cmd)"
}

exec_tgt() {

	local remote_dir=$1
	local remote_cmd=$2

	echo $(exec_remote "${remote_dir}" "${remote_cmd}" "${TGT_IP}" "${TGT_USER}" "${TGT_PASS}")
}

set +x
