require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Geeklet do

  before { @geeklet = Geeklet.new }

  subject { @geeklet }

  it { should respond_to :run }
  
  describe :run do

    context "When params is nil" do      
      subject { @geeklet.run(nil)}
      it { should be_true }      
    end

    context "When params is empty" do      
      subject { @geeklet.run([])}
      it { should be_true }      
    end

    context "When params has items" do
      subject { @geeklet.run(["one", 2, "three"])}      
      it { should be_true }      
    end
    
    context "When params has 'help' as first item" do
      it "should show help and exit" do
        @geeklet.should_receive(:showHelp)
        Kernel.should_receive(:exit)
        
        @geeklet.run(["Help", 2, "4.5"])
      end
    end

  end
  
  describe :isHelp do
    
    it "should return true when param is 'help'" do
      help = ['Help', 'help', "HeLp"]      
      help.each { |param| @geeklet.isHelp?(param).should be_true }
    end
    
    it "should be false when the param is not 'help'" do
      not_help = [2, nil, ""]
      not_help.each { |param| @geeklet.isHelp?(param).should be_false }
    end
    
  end
  
  
  describe :showHelp do
    
    it "should display usage information" do
      @geeklet.should_receive(:name).and_return("Script Name")
      @geeklet.should_receive(:description).and_return("Some script description")
      Kernel.should_receive(:puts).with(
<<-EOS
    Geeklet: Script Name

    description: Some script description

    USAGE: goes here.
EOS
)      

      @geeklet.showHelp
    end
    
  end
  
end