#!/bin/bash
#
# Copyright © 2020 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: Inode monitor script.
# User: Robin@ExinPool
# Date: 2021-01-24
# Time: 13:28:45

# load the config library functions
source config.shlib

# load configuration
service="$(config_get SERVICE)"
mem_num="$(config_get MEM_NUM)"
mem_num_var=`free -m | awk '/Mem:/ { printf("%3.1f", $3/$2*100) }'`
log_file="$(config_get LOG_FILE)"
webhook_url="$(config_get WEBHOOK_URL)"
access_token="$(config_get ACCESS_TOKEN)"

if [ ${mem_num_var} -lt ${mem_num} ]
then
    log="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` INFO ${service} mem num is normal."
    echo $log >> $log_file
else
    log="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` ERROR ${service} 内存使用率已超过 ${mem_num}，请及时处理。"
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