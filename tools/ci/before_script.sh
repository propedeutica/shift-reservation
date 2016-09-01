set -v

if [[ "$TEST_SUITE" == "rspec" ]]; then
  bin/rails db:drop RAILS_ENV=test
  bin/rails db:setup RAILS_ENV=test
fi

set +v
