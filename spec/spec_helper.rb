$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'fluent/test'
require 'fluent/test/helpers'
require 'fluent/test/driver/filter'
require 'fluent/plugin/filter_jq'
require 'time'

# Disable Test::Unit
module Test::Unit::RunCount; def run(*); end; end

RSpec.configure do |config|
  config.before(:all) do
    Fluent::Test.setup
  end
end

def create_driver(options = {})
  fluentd_conf = <<-EOS
type object_flatten
jq "#{options.fetch(:jq)}"
  EOS

  if options[:no_hash_root_key]
    fluentd_conf << <<-EOS
no_hash_root_key #{options[:no_hash_root_key]}
    EOS
  end

  Fluent::Test::Driver::Filter.new(Fluent::Plugin::JqFilter).configure(fluentd_conf)
end
