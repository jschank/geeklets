require 'unregistered_config_value_error'
require 'configuration_required_error'
require 'trollop'
require 'yaml'

module Configurable
  
  # configurations should be a hash of hashes, where the first key is the calculator type, and the second key is the tag
  def configurations
    @@configuration ||= {}
  end

  def isHelp?(param)
    param.to_s.downcase == 'help'
  end

  def configurableValue(group, key)
    raise UnregisteredConfigValueError unless configurations.include?(group)
    raise UnregisteredConfigValueError unless configurations[group].include?(key)
    value = configurations[group][key][:override] || configurations[group][key][:stored] || configurations[group][key][:default]
    raise ConfigurationRequiredError unless value
    value
  end
  
  def registerConfiguration(group, key, options = {})
    configurations[group] ||= {}
    configurations[group][key] = options
  end
    
  def command_parser(group)
    groupConfigs = configurations[group]
    return unless groupConfigs #if there are no configs defined, there is nothing to do.
    
    parser = Trollop::Parser.new do
      groupConfigs.each do |key, options|
        # our concept of a default is different from trollop's, so remove any default key and value
        defaultValue = options[:stored] || options[:default]
        if defaultValue
          opt key, options[:description], options.merge({ :default => defaultValue })
        else
          opt key, options[:description], options
        end
      end
    end
  end  
  
  def add_overrides(group, params)
    return if (params.nil? || params.empty?) # nothing to do in this case
    raise Trollop::HelpNeeded if isHelp?(params[0])

    groupConfigs = configurations[group]
    trollop_opts = command_parser(group).parse(params)
    trollop_opts.each do |key, value| 
      groupConfigs[key][:override] = value if groupConfigs.key?(key) 
    end
    
    # puts "trollop opts:"
    # puts trollop_opts.to_yaml
    # puts
    # puts "group configs:"
    # puts groupConfigs.to_yaml
  end

  def self.included(base)
    base.extend(Configurable)
  end

end