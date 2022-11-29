#!/bin/sh

rm -r /app/tmp/pids/server.pid

bundle install -j "$(getconf _NPROCESSORS_ONLN)"

gem install rails -v6.1.0
gem install sqlite3 -v1.4

rails s -b 0.0.0.0 -p 3001
