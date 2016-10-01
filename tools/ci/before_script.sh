set -v

if [[ "$TEST_SUITE" == "rspec" ]]; then
  # bin/rails db:drop db:create db:migrate RAILS_ENV=test --trace
  # bin/rails db:environment:set RAILS_ENV=test --trace
  bin/rails db:environment:set RAILS_ENV=test
  bin/rails db:migrate RAILS_ENV=test
fi

set +v
