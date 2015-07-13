
describe Fluent::JqFilter do
  let(:time) { Time.parse('2015/05/24 18:30 UTC').to_i }
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
    records.each do |record|
      driver.emit(record, time)
    end

    driver.run
  end

  subject { driver.emits }

  context '.' do
    it do
      is_expected.to eq [
        ["test.default", time, {"foo"=>"bar", "zoo"=>"baz"}],
        ["test.default", time, {"foo"=>"zoo", "bar"=>"baz"}]
      ]
    end
  end

  context '{new_foo:.foo}' do
    it do
      is_expected.to eq [
        ["test.default", time, {"new_foo"=>"bar"}],
        ["test.default", time, {"new_foo"=>"zoo"}]
      ]
    end
  end

  context '.[]' do
    it do
      is_expected.to eq [
        ["test.default", time, {"."=>"baz"}],
        ["test.default", time, {"."=>"bar"}],
        ["test.default", time, {"."=>"baz"}],
        ["test.default", time, {"."=>"zoo"}]
      ]
    end
  end

  context '.[]' do
    let(:fluentd_conf) { {no_hash_root_key: 'root'} }

    it do
      is_expected.to eq [
        ["test.default", time, {"root"=>"baz"}],
        ["test.default", time, {"root"=>"bar"}],
        ["test.default", time, {"root"=>"baz"}],
        ["test.default", time, {"root"=>"zoo"}]
      ]
    end
  end
end
