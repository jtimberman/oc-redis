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
require 'chef/resource/lwrp_base'

# Creates a redis_instance resource.
class Chef::Resource::RedisInstance < Chef::Resource::LWRPBase
  self.resource_name = 'redis_instance'

  actions :create, :delete
  default_action :create

  attribute :instance_name, :kind_of => String, :name_attribute => true
  attribute :port, :kind_of => [String, Fixnum], :required => true
  attribute :user, :kind_of => String, :default => 'redis'
  attribute :group, :kind_of => String, :default => 'redis'
  attribute :bind, :kind_of => String, :default => '0.0.0.0'
  attribute :config, :kind_of => [Hash, Mash], :default => {}
  attribute :ulimit, :kind_of => [String, Fixnum], :default => '65536'
end
