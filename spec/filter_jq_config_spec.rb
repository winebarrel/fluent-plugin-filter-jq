describe 'Fluent::Plugin::JqFilter#configure' do
  subject do |example|
    param = example.full_description.split(/\s+/)[1]
    create_driver(fluentd_conf).instance.send(param)
  end

  let(:fluentd_conf) do |example|
    conf = {jq: '.'}
    param = example.full_description.split(/\s+/)[1]
    value = example.example_group.description

    unless value.empty?
      conf.update(param.to_sym => value)
    end

    conf
  end

  describe 'jq' do
    context '{new_foo: .foo}' do
      it { is_expected.to eq "{new_foo: .foo}" }
    end
  end

  describe 'no_hash_root_key' do
    context '' do
      it { is_expected.to eq '.' }
    end

    context 'root' do
      it { is_expected.to eq 'root' }
    end
  end
end
