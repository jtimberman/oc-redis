if defined?(ChefSpec)
  def create_redis_instance(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:redis_instance, :create, resource_name)
  end

  def delete_redis_instance(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:redis_instance, :delete, resource_name)
  end
end
