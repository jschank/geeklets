require 'configurable'

class Geeklet
  include Configurable
  
  
  def name
    self.class.to_s
  end
  
  def description
    "No description specified for this geeklet."
  end

  def show_help(group)
    parser = command_parser(group)
    Kernel.puts(
<<-EOS
Geeklet: #{name}

Description: #{description}

EOS
)
    parser.educate 
  end

  def run(group, params)
    begin
      add_overrides(group, params)
    rescue => e
      show_help(group)
      # Kernel.puts e.inspect
      Kernel.exit
    end
    true
  end

end