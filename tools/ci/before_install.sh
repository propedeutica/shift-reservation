set -v

echo "gem: --no-ri --no-rdoc --no-document" > ~/.gemrc
travis_retry gem install bundler -v ">= 1.11.1"

# suites that need bower assets to work: javascript, vmdb
if [[ "$TEST_SUITE" = "rspec" ]]; then
  which bower || npm install -g bower
  bower install --allow-root -F --config.analytics=false
fi

set +v
