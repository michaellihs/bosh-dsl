require 'dsl'
require 'helpers'

RSpec.describe Deployment, "#manifest" do

  it 'produces a simple yaml string' do
    deployment = Deployment.new.manifest do
      name 'my-manifest'
    end

    expect(deployment.to_yaml).to eq (<<-EOF).gsub(/^\s{6}/, '')
      ---
      name: my-manifest
    EOF
  end

  it 'allows nested elements' do
    deployment = Deployment.new.manifest do
      name 'my-manifest'
      nested do
        inner 'inner_value'
        inner_nested do
          inner_inner 'inner_inner_value'
        end
      end
      outer 'another-value'
    end

    expect(deployment.to_yaml).to eq (<<-EOF).gsub(/^\s{6}/, '')
      ---
      name: my-manifest
      nested:
        inner: inner_value
        inner_nested:
          inner_inner: inner_inner_value
      outer: another-value
    EOF
  end

  it 'allows access to local variables' do
    my_var = 'testvar'

    deployment = Deployment.new.manifest do
      var my_var
    end

    expect(deployment.to_yaml).to eq (<<-EOF).gsub(/^\s{6}/, '')
      ---
      var: #{my_var}
    EOF
  end

  it 'allows usage of local methods' do
    deployment = Deployment.new.manifest do

      # TODO find out how we can declare methods outside of the manifest block
      def my_func(func_var)
        func_var.upcase
      end

      func_val my_func("lower")
    end

    expect(deployment.to_yaml).to eq (<<-EOF).gsub(/^\s{6}/, '')
      ---
      func_val: LOWER
    EOF
  end

  it 'allows usage of library methods' do
    deployment = Deployment.new.manifest do
      secret Helpers::Credentials.get_or_create('secret-key')
    end

    expect(deployment.to_yaml).to eq (<<-EOF).gsub(/^\s{6}/, '')
      ---
      secret: SECRET secret-key
    EOF
  end

  it 'supports arrays as expected' do
    deployment = Deployment.new.manifest do
      name 'my-deployment'
      instances [1,2,3,4]
    end

    expect(deployment.to_yaml).to eq (<<-EOF).gsub(/^\s{6}/, '')
      ---
      name: my-deployment
      instances:
      - 1
      - 2
      - 3
      - 4
    EOF
  end

  it 'creates yaml lists as expected' do
    deployment = Deployment.new.manifest do
      name 'my-deployment'
      instances :array do
        __ do
          key_1_1 'value_1_1'
          key_1_2 'value_1_2'
        end
        __ do
          key_2_1 'value_2_1'
          key_2_2 'value_2_2'
        end
      end
    end

    expect(deployment.to_yaml).to eq (<<-EOF).gsub(/^\s{6}/, '')
      ---
      name: my-deployment
      instances:
      - key_1_1: value_1_1
        key_1_2: value_1_2
      - key_2_1: value_2_1
        key_2_2: value_2_2
    EOF
  end

  it 'allows override of values' do
    deployment = Deployment.new.manifest do
      name 'my-deployment'
      other 'value'
      name 'override-deployment'
    end

    expect(deployment.to_yaml).to eq (<<-EOF).gsub(/^\s{6}/, '')
      ---
      name: override-deployment
      other: value
    EOF
  end

end
