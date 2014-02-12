#
# Author: Joshua Timberman <joshua@getchef.com>
# Copyright (c) 2014, Chef Software, Inc <legal@getchef.com>
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
require 'chef/provider/lwrp_base'
require_relative './helpers.rb'
require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

# Creates a provider for the redis_instance resource
class Chef::Provider::RedisInstance < Chef::Provider::LWRPBase
  use_inline_resources if defined?(:use_inline_resources)

  def whyrun_supported?
    true
  end

  action :create do
    redis_instance_template
    redis_service
  end

  action :delete do
    redis_instance_template(:delete)
    redis_service([:stop, :disable])
  end

  def redis_service(service_action = [:enable])
    # I should feel bad about this, but I don't
    @run_context.include_recipe 'runit'
    runit_service "redis-#{new_resource.instance_name}" do
      options(
        'name' => new_resource.instance_name,
        'user' => new_resource.user,
        'ulimit' => new_resource.ulimit
      )
      run_template_name 'redis-instance'
      default_logger true
      restart_on_update false
      cookbook 'oc-redis'
      action service_action
    end
  end

  def redis_instance_template(template_action = :create)
    # TODO: There appears to be a race condition where notifying the
    # runit_service will timeout and fail. Since the template comes
    # before the service, the initial setup will be fine.
    template "/etc/redis/#{new_resource.instance_name}.conf" do
      source 'redis.conf.erb'
      cookbook 'oc-redis'
      owner new_resource.user
      group new_resource.group
      mode 00644
      variables :config => redis_config
      action template_action
    end
  end

  def redis_config
    new_resource.config.merge(
      'logfile' => 'stdout',
      'daemonize' => 'no',
      'port' => new_resource.port,
      'bind' => new_resource.bind
    )
  end
end
