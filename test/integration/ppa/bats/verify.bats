@test "the ppa is enabled" {
  [ -f "/etc/apt/sources.list.d/redis-ppa.list" ]
}

@test "the package is the version from the ppa" {
  redis-cli --version | grep -qx "redis-cli 2.8.5"
}
