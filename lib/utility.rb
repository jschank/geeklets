class Utility
  
  def self.wrap_text(text, width, indent = 0, option = :all)
    raise ArgumentError.new("Width must be at least 1 character wide.") if width <= 1
    raise ArgumentError.new("Indent must be 0 for no indenting or a positive number.") if indent < 0
    raise ArgumentError.new("Wrapping width must be greater than the indent amount.") if width <= indent
    lines = []
    
    curline = nil
    indent_text = " " * indent
    text.split.each do |word|
      if (curline == nil)
        # start a new line
        curline = ""
        curline << indent_text if ( (option == :all) || (option == :indent && lines.count == 0) || (option == :outdent && lines.count > 0) )
        curline << word << " "
      elsif (curline.length + word.length <= width)
        curline << word << " "
      else
        lines << curline.chop
        curline = nil
        redo
      end
      
    end
    lines << curline.chop if curline
    lines.join("\n").chomp  
  end
end