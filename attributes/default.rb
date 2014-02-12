#
# Cookbook Name:: oc-redis
# Attributes:: default
#
# Copyright (C) 2014, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
default['redis']['service_state'] = [:enable, :start]
default['redis']['include_ppa'] = false

# Configuration `config` directives are rendered in the default config
# and may be useful when using custom instances.
default['redis']['config']['daemonize'] = 'yes'
default['redis']['config']['pidfile'] = '/var/run/redis/redis-server.pid'
default['redis']['config']['port'] = '6379'
default['redis']['config']['bind'] = '127.0.0.1'
# default['redis']['config']['unixsocket'] = '/var/run/redis/redis.sock'
default['redis']['config']['timeout'] = '300'
default['redis']['config']['loglevel'] = 'notice'
default['redis']['config']['logfile'] = '/var/log/redis/redis-server.log'
# default['redis']['config']['syslog-enabled'] = 'no'
# default['redis']['config']['syslog-ident'] = 'redis'
# default['redis']['config']['syslog-facility'] = 'local0'
default['redis']['config']['databases'] = '16'
default['redis']['config']['save'] = ['900 1', '300 10', '60 10000']
default['redis']['config']['rdbcompression'] = 'yes'
default['redis']['config']['dbfilename'] = 'dump.rdb'
default['redis']['config']['dir'] = '/var/lib/redis'
# default['redis']['config']['slaveof'] = nil
# default['redis']['config']['masterauth'] = nil
default['redis']['config']['slave-serve-stale-data'] = 'yes'
# default['redis']['config']['requirepass'] = nil
# default['redis']['config']['maxclients'] = '128'
# default['redis']['config']['maxmemory'] = "#{node['memory']['total'].to_f * 0.60}kb"
# default['redis']['config']['maxmemory-policy'] = 'volatile-lru'
# default['redis']['config']['maxmemory-samples'] = '3'
default['redis']['config']['appendonly'] = 'no'
# default['redis']['config']['appendfilename'] = 'appendonly.aof'
default['redis']['config']['appendfsync'] = 'everysec'
default['redis']['config']['no-appendfsync-on-rewrite'] = 'no'
default['redis']['config']['vm-enabled'] = 'no'
default['redis']['config']['vm-swap-file'] = '/var/lib/redis/redis.swap'
default['redis']['config']['vm-max-memory'] = '0'
default['redis']['config']['vm-page-size'] = '32'
default['redis']['config']['vm-pages'] = '134217728'
default['redis']['config']['vm-max-threads'] = '4'
default['redis']['config']['hash-max-zipmap-entries'] = '512'
default['redis']['config']['hash-max-zipmap-value'] = '64'
default['redis']['config']['list-max-ziplist-entries'] = '512'
default['redis']['config']['list-max-ziplist-value'] = '64'
default['redis']['config']['set-max-intset-entries'] = '512'
default['redis']['config']['activerehashing'] = 'yes'
default['redis']['config']['include'] = []
