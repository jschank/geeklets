$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'pathname'
require 'utility'
require 'trollop'
require 'geeklet'

class Geeklets

  def initialize(scripts = {})
    @geeklet_scripts = scripts
    if @geeklet_scripts.empty?
      cwd = File.dirname(__FILE__)
      children = Pathname.new(cwd).children
      children.reject! { |child| !child.directory? }
      children.each do |child_dir|
        geeklet_name = child_dir.basename.to_s
        geeklet_file = geeklet_name.downcase
        begin
          Kernel.require "#{geeklet_name}/#{geeklet_file}"
          @geeklet_scripts[geeklet_name] = Kernel.eval("#{geeklet_name}.new")
        rescue => e
          Kernel.puts "Problem loading #{geeklet_name} geeklet."
          Kernel.puts e.inspect
          Kernel.puts e.backtrace
          next
        end
      end
    end
  end
  
  def show_usage
    puts "Usage: geeklets <geeklet-script> [relevant-parameters-for-script]"
    puts
  end

  def show_known_scripts
    Kernel.puts "These are the currently known geeklet scripts:"
    Kernel.puts
    Kernel.puts "There are no defined geeklet scripts." if @geeklet_scripts.empty?
    @geeklet_scripts.keys.sort.each { |key| Kernel.puts "\t#{key}" }
    Kernel.puts
  end

  def run(params)
    if params.nil? || params.empty?
      show_usage
      show_known_scripts
    else
      geeklet = params.shift
      if @geeklet_scripts.include?(geeklet)
        @geeklet_scripts[geeklet].run(params)
      else
        Kernel.puts "I do not know how to run the #{geeklet} geeklet."
        show_known_scripts
      end
    end
  end

end
