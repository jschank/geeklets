require 'configurable'

class Geeklet
  include Configurable
  
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

  def run(params)
    if !params.nil? && !params.empty? && isHelp?(params[0])
      showHelp
      Kernel.exit
    end
    true
  end

end