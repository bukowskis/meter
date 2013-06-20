require 'meter'

def ensure_class_or_module(full_name, class_or_module)
  full_name.to_s.split(/::/).inject(Object) do |context, name|
    begin
      context.const_get(name)
    rescue NameError
      if class_or_module == :class
        context.const_set(name, Class.new)
      else
        context.const_set(name, Module.new)
      end
    end
  end
end

def ensure_module(name)
  ensure_class_or_module(name, :module)
end

def ensure_class(name)
  ensure_class_or_module(name, :class)
end

RSpec.configure do |config|
  config.before do
    Meter.config.logger = nil
  end

  config.after do
    Meter.reset!
  end
end
