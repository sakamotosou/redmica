#!/bin/bash
VALUE=$1
if [ -n "$VALUE" ] ; then
    echo "config.time_zone = '${VALUE}'" > config/additional_environment.rb
    bundle exec rails runner "p Time.current" -e test
    bundle exec rake test
    bundle exec rake redmine:plugins:test NAME=redmine_issue_templates RAILS_ENV=test
    sed -i "/Options.new/s/$/(args: [\'--headless\', \'--no-sandbox\', \'--disable-gpu\', \'--window-size=1280,800\'])/g" ../../plugins/redmine_issue_templates/spec/rails_helper.rb
    DRIVER=headless RAILS_ENV=test bundle exec rspec -I ../../plugins/redmine_issue_templates/spec
fi

