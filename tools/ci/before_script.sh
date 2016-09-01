set -v

if [[ "$TEST_SUITE" == "rspec" ]]; then
  RAILS_ENV=test bundle exec rake db:migrate --trace
fi

set +v
