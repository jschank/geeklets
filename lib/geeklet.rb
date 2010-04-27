require 'configurable'

class Geeklet
  include Configurable
  
  
  def name
    self.class.to_s
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

  def run(group, params)
    begin
      add_overrides(group, params)
    rescue => e
      showHelp
      # Kernel.puts e.inspect
      Kernel.exit
    end
    true
  end

end