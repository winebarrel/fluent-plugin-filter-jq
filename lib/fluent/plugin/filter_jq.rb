require 'fluent_plugin_filter_jq/version'
require 'multi_json'
require 'jq'

module Fluent
  class JqFilter < Filter
    Plugin.register_filter('jq', self)

    config_param :jq, :string
    config_param :no_hash_root_key, :string, :default => '.'

    def filter_stream(tag, es)
      result_es = Fluent::MultiEventStream.new

      es.each do |time, record|
        jq_search(time, record, result_es)
      end

      result_es
    rescue => e
      log.warn e.message
      log.warn e.backtrace.join(', ')
    end

    private

    def jq_search(time, record, result_es)
      json = MultiJson.dump(record)

      JQ(json).search(@jq) do |value|
        unless value.is_a?(Hash)
          value = {@no_hash_root_key => value}
        end

        result_es.add(time, value)
      end
    end
  end
end
