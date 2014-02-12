@test "configured for port 6379 (default redis port)" {
  grep -qx 'port 6379' /etc/redis/redis.conf
}

@test "redis-server is running on 127.0.0.1:6379" {
  # by default, redis-cli will use -h 127.0.0.1 and -p 6379
  redis-cli ping
}

@test "sets up the redis-fig runit service" {
  sv status redis-fig
  redis-cli -p 8300 ping
}

@test "sets up the redis-newton instance w/ attribute config" {
  sv status redis-newton
  grep -qx 'port 9700' /etc/redis/newton.conf
  grep -qx 'pidfile /var/run/redis/redis-server.pid' /etc/redis/newton.conf
  grep -qx 'bind 10.0.2.15' /etc/redis/newton.conf
  redis-cli -h 10.0.2.15 -p 9700 ping
}

@test "sets up redis-fig-newton instance" {
  sv status redis-fig-newton
  grep -qx 'port 7600' /etc/redis/fig-newton.conf
  redis-cli -p 7600 ping
}
