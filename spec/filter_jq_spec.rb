
describe Fluent::Plugin::JqFilter do
  include Fluent::Test::Helpers

  let(:time) { event_time('2015/05/24 18:30 UTC') }
  let(:fluentd_conf) { {} }

  let(:driver) do |example|
    fluentd_conf.update(jq: example.example_group.description )
    create_driver(fluentd_conf)
  end

  let(:records) do
    [
      {"foo"=>"bar", "zoo"=>"baz"},
      {"foo"=>"zoo", "bar"=>"baz"}
    ]
  end

  before do
    driver.run(default_tag: 'test.default') do
      records.each do |record|
        driver.feed(time, record)
      end
    end
  end

  subject { driver.filtered }

  context '.' do
    it do
      is_expected.to eq [
        [time, {"foo"=>"bar", "zoo"=>"baz"}],
        [time, {"foo"=>"zoo", "bar"=>"baz"}]
      ]
    end
  end

  context '{new_foo:.foo}' do
    it do
      is_expected.to eq [
        [time, {"new_foo"=>"bar"}],
        [time, {"new_foo"=>"zoo"}]
      ]
    end
  end

  context '.[]' do
    it do
      is_expected.to match_array [
        [time, {"."=>"baz"}],
        [time, {"."=>"bar"}],
        [time, {"."=>"baz"}],
        [time, {"."=>"zoo"}]
      ]
    end
  end

  context '.[]' do
    let(:fluentd_conf) { {no_hash_root_key: 'root'} }

    it do
      is_expected.to match_array [
        [time, {"root"=>"baz"}],
        [time, {"root"=>"bar"}],
        [time, {"root"=>"baz"}],
        [time, {"root"=>"zoo"}]
      ]
    end
  end
end
