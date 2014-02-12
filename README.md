# oc-redis cookbook

This is our redis cookbook. It is intended to be simple to meet our needs, and not to support every single Redis installation type, configuration option, or platform.

It is out of scope to support platforms we're not using in our infrastructure (namely, Ubuntu).

## Requirements

Chef 11+.

### Platform:

This cookbook is tested on the following platforms with test-kitchen.

* Ubuntu 12.04

### Cookbooks:

* apt - used for the `apt_repository` resource to optionally add a PPA.
* runit - used in the `redis_instance` resource to create a `runit_service` for each instance.

## Attributes

* `node['redis']['service_state']` - The actions for the `service[redis-server]` resource. The default is to enable and start the service, matching the package installation policy from the default .deb. Set this to `[:disable, :stop]` if the default redis server is not to be used.
* `node['redis']['include_ppa']` - Whether to include [Chris Lea's ppa for Redis packages](https://launchpad.net/~chris-lea/+archive/redis-server). Default to false. Set to true to use a more recent version of Redis than is available (2.8 on Ubuntu 12.04, for example).
* `node['redis']['config']` - A hash of configuration options for `template[/etc/redis/redis.conf]` in the `recipe[oc-redis::config]`. The template will dynamically render based on these config directives. Each key should be a Redis configuration directive. The template will iterate over array values and write out the directive for each, mainly for the `save` configuration.

## Recipes

The recipes are composable so end users can use the ones they wish.

### default

Includes the other recipes in the required order as a bespoke sane default setup.

### config

Renders `/etc/redis/redis.conf` from a template.

### install

Installs the `redis-server` package.

### service

Manages the `redis-server` service.

### user

Creates the `redis` group and user.

## Resources

### redis_instance

This resource creates a "Redis Instance" running on the specified port as a `runit` service. An instance-specific configuration will be written to `/etc/redis/$instance_name.conf` and the runit service will be `/etc/service/redis-$instance_name`, where $instance_name is the `instance_name` attribute (see below).

#### Actions

* create - **Default** This action creates the instance-specific config and runit service.
* delete - This action deletes the instance-specific config and runit service.

#### Attributes

* instance_name - **name attribute** the name of the redis instance. This will have `redis-` prepended for the `runit_service`.
* port - **Required** the port that the instance listens on. Should be different than `6379`, unless the `redis-server` service is disabled.
* user - the user that the instance runs as and owns the config, default `redis`.
* group - the group that owns the config, default `redis`.
* bind - the IP address to listen on, used as the `bind` configuration directive in the redis config. Default is `0.0.0.0`.
* config - A hash of configuration options passed to the redis configuration template. Don't pass the `port` or `bind` options here, they're merged from the resource attributes.
* ulimit - the ulimit for the `run` script launched by runit for the instance.

#### Examples

These examples are used in the `test::lwrp` recipe via the `default` suite in the `.kitchen.yml` when testing this cookbook via test-kitchen.

Create a redis instance with all the defaults running on port 8300.

```ruby
redis_instance 'fig' do
  port 8300
end
```

Pass in the entirety of the config attributes for the configuration. This will get merged. This is probably what many users will want who aren't modifying the config in some way from the defaults.

```ruby
redis_instance 'newton' do
  config node['redis']['config'].to_hash
  bind node['ipaddress']
  port 9700
end
```

Provide a different instance name.

```ruby
redis_instance 'not-a-cookie' do
  instance_name 'fig-newton'
  port 10600
end
```

### Bugs

In testing there was a race condition where the runit service would time out when a restart notification was sent from the instance's redis config. It was deemed acceptable to ship this as is because the template gets written before the service is managed so the initial configuration will be fine.

## Testing

The cookbook provides the following Rake tasks for testing:

    rake foodcritic                   # Lint Chef cookbooks
    rake integration                  # Alias for kitchen:all
    rake kitchen:all                  # Run all test instances
    rake kitchen:default-ubuntu-1204  # Run default-ubuntu-1204 test instance
    rake rubocop                      # Run RuboCop style and lint checks
    rake spec                         # Run ChefSpec examples
    rake test                         # Run all tests

## License and Author

- Author: Joshua Timberman <joshua@getchef.com>
- Copyright (C) 2014 Chef Software, Inc. <legal@getchef.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
