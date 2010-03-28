require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Utility do
  
  context "word wrapping" do
          
  end
  
  context "word wrapping without indents" do
  
    it "should reject invalid wrapping width" do
      invalid_widths = [-5, -1, 0, 1]
      invalid_widths.each do |width|
        lambda {Utility.wrap_text("Some Text", width)}.should raise_error(ArgumentError)
      end
    end
    
    it "should wrap a long string appropriately" do
      long_text = "This is a long string that will need to be wrapped onto multiple lines."      
      wrapped_text = Utility.wrap_text(long_text, 20)
      wrapped_text.should == "This is a long\nstring that will\nneed to be wrapped\nonto multiple lines."      
      wrapped_text.split("\n").count.should == 4
      wrapped_text.split("\n").all? {|line| line.length <= 20}.should be_true
    end
  
    it "should allow short strings to remain short" do
      short_text = "This is a short string."
      wrapped_text = Utility.wrap_text(short_text, 100)
      wrapped_text.should == short_text
    end
    
    
  end
  
  context "word wrapping with indents" do
    
    before :each do
      @long_text = "This is a long string that will need to be wrapped onto multiple lines."
    end
    
    it "should reject invalid indent values" do
      invalid_indents = [-5, -1]
      invalid_indents.each do |indent|
        lambda {Utility.wrap_text(@long_text, 20, indent)}.should raise_error(ArgumentError)
      end
    end
    
    it "should reject wrapping widths that are too small for the indent value" do
      invalid_widths = [1, 6, 10]
      invalid_widths.each do |width|
        lambda {Utility.wrap_text(@long_text, width, 10)}.should raise_error(ArgumentError)
      end
    end
    
    it "should allow indenting of all rows" do
      wrapped_text = Utility.wrap_text(@long_text, 25, 5, :all)
      wrapped_text.should == "     This is a long\n     string that will\n     need to be wrapped\n     onto multiple lines."
      wrapped_text.split("\n").count.should == 4
      wrapped_text.split("\n").all? {|line| line.length <= 25 && line[0..4] == "     "}.should be_true
    end
    
    it "should allow indenting of the first row only" do
      wrapped_text = Utility.wrap_text(@long_text, 25, 5, :indent)
      wrapped_text.should == "     This is a long\nstring that will need to\nbe wrapped onto multiple\nlines."
      wrapped_text.split("\n").count.should == 4
      wrapped_text.split("\n").all? {|line| line.length <= 25 }.should be_true
    end
    
    it "should allow indenting of all but the first row" do
      wrapped_text = Utility.wrap_text(@long_text, 25, 5, :outdent)
      wrapped_text.should == "This is a long string\n     that will need to be\n     wrapped onto\n     multiple lines."
      wrapped_text.split("\n").count.should == 4
      wrapped_text.split("\n").all? {|line| line.length <= 25 }.should be_true
    end
    
  end
  
end
