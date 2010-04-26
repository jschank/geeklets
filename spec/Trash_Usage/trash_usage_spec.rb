require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'Trash_Usage/trash_usage'

describe Trash_Usage do

  before { @script = Trash_Usage.new }
  
  subject { @script }

  describe "in general" do
    it { should be_a_kind_of(Geeklet) }
  end

  describe :run do
    
    it "should get the trash usage" do
      
      Kernel.should_receive(:system).with("du -sh ~/.Trash/ | awk '{print \"Trash is using \"$1}'")
      
      @script.run([])
    end
    
  end

end