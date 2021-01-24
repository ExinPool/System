#!/bin/bash
#
# Copyright © 2020 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: Inode monitor script.
# User: Robin@ExinPool
# Date: 2021-01-08
# Time: 10:13:44

# load the config library functions
source config.shlib

# load configuration
service="$(config_get SERVICE)"
inode_num="$(config_get INODE_NUM)"
declare -a disk_arr="$(config_get DISK_ARRAY)"
log_file="$(config_get LOG_FILE)"
webhook_url="$(config_get WEBHOOK_URL)"
access_token="$(config_get ACCESS_TOKEN)"

for disk in "${disk_arr[@]}"
do
    inode_num_var=`df -i | grep "$disk" | awk '{print $5}' | sed "s/%//g"`
    if [ ${inode_num_var} -lt ${inode_num} ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` INFO ${service} inode num is normal."
        echo $log >> $log_file
    else
        log="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` ERROR ${service} $disk inode 使用率已超过 ${inode_num}，请及时处理。"
        echo $log >> $log_file
        success=`curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' | awk -F',' '{print $1}' | awk -F':' '{print $2}'`
        if [ "$success" = "true" ]
        then
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
            echo $log >> $log_file
        else
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
            echo $log >> $log_file
        fi
    fi
done