#!/bin/bash
#
# Copyright © 2020 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: Inode monitor script.
# User: Robin@ExinPool
# Date: 2021-01-24
# Time: 14:11:48

TOKEN="YOUR_TOKEN_HERE"
mkdir -p /data/monitor/exinpool
cd /data/monitor/exinpool
git clone https://github.com/ExinPool/System

cd /data/monitor/exinpool/System/cpu && \cp config.cfg.defaults config.cfg && sed -i "s/ACCESS_TOKEN=YOUR_ACCESS_TOKEN/ACCESS_TOKEN=$TOKEN/g" config.cfg
cd /data/monitor/exinpool/System/disk && \cp config.cfg.defaults config.cfg && sed -i "s/ACCESS_TOKEN=YOUR_ACCESS_TOKEN/ACCESS_TOKEN=$TOKEN/g" config.cfg
cd /data/monitor/exinpool/System/mem && \cp config.cfg.defaults config.cfg && sed -i "s/ACCESS_TOKEN=YOUR_ACCESS_TOKEN/ACCESS_TOKEN=$TOKEN/g" config.cfg
cd /data/monitor/exinpool/System/inode && \cp config.cfg.defaults config.cfg && sed -i "s/ACCESS_TOKEN=YOUR_ACCESS_TOKEN/ACCESS_TOKEN=$TOKEN/g" config.cfg