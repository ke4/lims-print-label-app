ruby -e 'begin; require "bundler"; rescue LoadError; system "gem install bundler"; end'
bundle check || bundle install 
bundle exec ruby script/print_label.rb
