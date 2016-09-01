set -v

if [[ "$TEST_SUITE" == "rspec" ]]; then
  bin/rails db:reset
fi

set +v
