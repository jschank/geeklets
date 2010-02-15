$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'pathname'

class Geeklets

  def self.show_usage
    puts "Usage: geeklets <geeklet-script> [relevant-parameters-for-script]"
    puts 
  end
  
  def self.show_known_scripts
    puts "These are the currently known geeklet scripts:"
    puts
    script_inventory.each { |script| puts "\t#{script}"}
    puts
  end
  
  def self.script_inventory
    cwd = File.dirname(__FILE__)
    children = Pathname.new(cwd).children
    children.reject! { |child| !child.directory? }
    children.map! { |child| child.basename.to_s }
  end
  
  def self.run_geeklet(geeklet, params)
    puts "Ok, I'll run the geeklet #{geeklet}."

    require "#{geeklet}\\#{geeklet}"
    
    obj = eval("#{geeklet}.new")
    obj.run(params)
    
  end

  def self.run(params)
    if params.empty?
      show_usage
      show_known_scripts
    else
      geeklet = params.shift
      if script_inventory.include?(geeklet)
        run_geeklet(geeklet, params)
      else
        puts "I do not know how to run the #{geeklet} geeklet."
        show_known_scripts
      end
    end
    
  end

end