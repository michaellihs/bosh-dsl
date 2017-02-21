require 'yaml'

class Deployment

  def initialize
    init = {}
    @yaml_map = init
    @curr_yaml_elem = init
  end

  def manifest(*args, &block)
    yaml(nil, args, &block)
    self
  end

  def __(*args, &block)
    outer_elem = @curr_yaml_elem
    new_elem = {}
    @curr_yaml_elem << new_elem
    @curr_yaml_elem = new_elem
    instance_eval(&block)
    @curr_yaml_elem = outer_elem
  end

  def method_missing(m, *args, &block)
    yaml(m, args, &block)
  end

  def to_yaml
    @yaml_map.to_yaml
  end

  private

  def yaml(key, args, &block)
    value = find_string_content(args)
    unless value
      value = find_array_content(args)
    end

    outer_elem = @curr_yaml_elem

    unless key.nil?
      if value
        @curr_yaml_elem[key.to_s] = value
      elsif contains_array(args)
        @curr_yaml_elem[key.to_s] = []
        @curr_yaml_elem = @curr_yaml_elem[key.to_s]
      else
        @curr_yaml_elem[key.to_s] = {}
        @curr_yaml_elem = @curr_yaml_elem[key.to_s]
      end
    end
    if block_given?
      instance_eval(&block)
    end
    @curr_yaml_elem = outer_elem
  end

  def contains_array(args)
    args.detect{|arg| arg.is_a? Symbol and arg == :array}
  end

  def find_string_content(args)
    args.detect{|arg| arg.is_a? String or arg.is_a? Numeric }
  end

  def find_array_content(args)
    content = args.detect{|arg| arg.is_a? Array}
  end
end


# example usage

def current_version()
  '1.2.3'
end

deployment = Deployment.new.manifest do
  name 'mysql'
  #version current_version()
  #nested do
  #  inner 'inner_value'
  #end
  array :array do
    __ do

      key_1 'val_1'
    end
    __ do
      key_2 'val_2'
    end
  end
  # releases do
  #   _instance do
  #     name     'mysql'
  #     version  '1.2.3'
  #     sha1     'asdfasdfasdfasdf'
  #   end
  # end
end

puts deployment.to_yaml