require 'unregistered_config_value_error'
require 'configuration_required_error'

class Geeklet

  def initialize
    @configuration = {}
  end

  def isHelp?(param)
    param.to_s.downcase == 'help'
  end
  
  def name
    self.class
  end
  
  def description
    "No description specified for this geeklet."
  end

  def showHelp
    Kernel.puts( 
<<-EOS
    Geeklet: #{name}

    description: #{description}

    USAGE: goes here.
EOS
)
  end
  
  def configurableValue(key)
    raise UnregisteredConfigValueError unless @configuration.include?(key)
    raise ConfigurationRequiredError unless @configuration[key].include?(:default)
    @configuration[key][:default]
  end
  
  def registerConfiguration(key, options = {})
    @configuration[key] = options
  end

  def run(params)
    if !params.nil? && !params.empty? && isHelp?(params[0])
      showHelp
      Kernel.exit
    end
    true
  end

end