require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'Trash_Usage/trash_usage'

describe Trash_Usage do

  describe :run do

    before { @script = Trash_Usage.new }
    
    subject { @script }
    
    it "should get the trash usage" do
      
      Kernel.should_receive(:system).with("du -sh ~/.Trash/ | awk '{print \"Trash is using \"$1}'")
      
      @script.run([])
    end
    
  end

end