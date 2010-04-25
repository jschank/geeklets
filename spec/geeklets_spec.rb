require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Geeklets do
  
  before { @geeklets = Geeklets.new }
  
  subject { @geeklets }
  
  it { should respond_to :show_usage }
  it { should respond_to :show_known_scripts }
  it { should respond_to :run }
  
  describe :initialize do
    
    subject { @geeklets.initialize }
    
    
    
    
  end

end
