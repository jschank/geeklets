require 'unregistered_config_value_error'
require 'configuration_required_error'

module Configurable
  
  # configurations should be a hash of hashes, where the first key is the calculator type, and the second key is the tag
  def configurations
    @@configuration ||= {}
  end

  def configurableValue(group, key)
    raise UnregisteredConfigValueError unless configurations.include?(group)
    raise UnregisteredConfigValueError unless configurations[group].include?(key)
    raise ConfigurationRequiredError unless configurations[group][key].include?(:default)
    configurations[group][key][:default]
  end
  
  def registerConfiguration(group, key, options = {})
    configurations[group] ||= {}
    configurations[group][key] = options
  end

  def self.included(base)
    base.extend(Configurable)
  end

end