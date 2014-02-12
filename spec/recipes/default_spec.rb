require_relative '../spec_helper'

# Write unit tests with ChefSpec - https://github.com/sethvargo/chefspec#readme
describe 'oc-redis::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates the redis user' do #~FC005 - wtf is this finding? ignore it.
    expect(chef_run).to create_user('redis')
  end

  it 'creates the redis group' do
    expect(chef_run).to create_group('redis')
  end

  it 'installs the redis-server package' do
    expect(chef_run).to install_package('redis-server')
  end

  it 'creates the redis config with attribute content' do
    expect(chef_run).to render_file('/etc/redis/redis.conf').with_content('port 6379')
  end

  it 'notifies redis to restart when the template is updated' do
    resource = chef_run.template('/etc/redis/redis.conf')
    expect(resource).to notify('service[redis-server]').to(:restart)
  end

  it 'creates a redis-service resource' do
    expect(chef_run).to enable_service('redis-server')
    expect(chef_run).to start_service('redis-server')
  end
end
