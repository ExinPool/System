#!/bin/bash
#
# Copyright © 2020 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: CPU monitor script.
# User: Robin@ExinPool
# Date: 2021-01-24
# Time: 13:21:35

# load the config library functions
source config.shlib

# load configuration
service="$(config_get SERVICE)"
cpu_num="$(config_get CPU_NUM)"
cpu_num_var=`LC_ALL=C top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'`
log_file="$(config_get LOG_FILE)"
webhook_url="$(config_get WEBHOOK_URL)"
access_token="$(config_get ACCESS_TOKEN)"

echo $cpu_num_var
echo $cpu_num

if [ ${cpu_num_var} -lt ${cpu_num} ]
then
    log="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` INFO ${service} cpu num is normal."
    echo $log >> $log_file
else
    log="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` ERROR ${service} CPU 使用率已超过 ${cpu_num}，请及时处理。"
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
