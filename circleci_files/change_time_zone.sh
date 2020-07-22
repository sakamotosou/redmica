#!/bin/bash
VALUE=$1
if [ -n "$VALUE" ] ; then
    echo "config.time_zone = '${VALUE}'" > config/additional_environment.rb
    bundle exec rails runner "p Time.current" -e test
    bundle exec rake test
    bundle exec rake redmine:plugins:test NAME=redmine_issue_templates RAILS_ENV=test
    cp ../../circleci_files/redmine_issue_templates-rails_helper.rb ../../plugins/redmine_issue_templates/spec/rails_helper.rb
    DRIVER=headless RAILS_ENV=test bundle exec rspec -I ../../plugins/redmine_issue_templates/spec
fi
