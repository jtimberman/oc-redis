include_recipe 'runit'

redis_instance 'fig' do
  port 8300
end

redis_instance 'newton' do
  config node['redis']['config'].to_hash
  bind node['ipaddress']
  port 9700
end

redis_instance 'not-a-cookie' do
  instance_name 'fig-newton'
  port 7600
end
