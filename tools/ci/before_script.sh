set -v

if [[ "$TEST_SUITE" == "rspec" ]]; then
  bin/rails db:drop db:create db:migrate RAILS_ENV=test --trace
fi

set +v
