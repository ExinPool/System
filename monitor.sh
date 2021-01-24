#!/bin/bash
#
# Copyright © 2020 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: Inode monitor script.
# User: Robin@ExinPool
# Date: 2021-01-24
# Time: 13:44:13

# CPU
cd /data/monitor/exinpool/System/cpu && bash cpu_monitor.sh >> cpu_monitor.log &

# Disk
cd /data/monitor/exinpool/System/disk && bash disk_monitor.sh >> disk_monitor.log &

# Mem
cd /data/monitor/exinpool/System/mem && bash mem_monitor.sh >> mem_monitor.log &

# Inode
cd /data/monitor/exinpool/System/inode && bash inode_monitor.sh >> inode_monitor.log &