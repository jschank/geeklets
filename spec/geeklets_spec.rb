require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module GeekletExampleHelperMethods
  def mock_no_scripts
    mock_cwd = mock("cwd")
    mock_cwd_pathname = mock("cwd Pathname")
    mock_children = []
  
    File.should_receive(:dirname).with(any_args()).and_return(mock_cwd)
    Pathname.should_receive(:new).with(mock_cwd).and_return(mock_cwd_pathname) 
    mock_cwd_pathname.should_receive(:children).and_return(mock_children)
    mock_children.should_receive(:reject!)
    
  
    geeklets = Geeklets.new
  end

  def mock_some_scripts_no_problems
    mock_cwd = mock("cwd")
    mock_cwd_pathname = mock("cwd Pathname")
    mock_children = [ mock("Dir1"), mock("Dir2"), mock("Dir3")]
    mock_children_basenames = ["Dir1.Basename", "Dir2.Basename", "Dir3.Basename"]
    mock_script_1 = mock("script1")
    mock_script_2 = mock("script2")
    mock_script_3 = mock("script3")
  
    File.should_receive(:dirname).with(any_args()).and_return(mock_cwd)
    Pathname.should_receive(:new).with(mock_cwd).and_return(mock_cwd_pathname) 
    mock_cwd_pathname.should_receive(:children).and_return(mock_children)
    mock_children[0].should_receive(:directory?).and_return(true)    
    mock_children[1].should_receive(:directory?).and_return(true)    
    mock_children[2].should_receive(:directory?).and_return(true)    

    mock_children[0].should_receive(:basename).and_return(mock_children_basenames[0])    
    Kernel.should_receive(:require).with("Dir1.Basename/dir1.basename")
    Kernel.should_receive(:eval).with("Dir1.Basename.new").and_return(mock_script_1)

    mock_children[1].should_receive(:basename).and_return(mock_children_basenames[1])    
    Kernel.should_receive(:require).with("Dir2.Basename/dir2.basename")
    Kernel.should_receive(:eval).with("Dir2.Basename.new").and_return(mock_script_2)

    mock_children[2].should_receive(:basename).and_return(mock_children_basenames[2])    
    Kernel.should_receive(:require).with("Dir3.Basename/dir3.basename")
    Kernel.should_receive(:eval).with("Dir3.Basename.new").and_return(mock_script_3)
  
    geeklets = Geeklets.new
  end

  def mock_some_scripts_with_problems
    mock_cwd = mock("cwd")
    mock_cwd_pathname = mock("cwd Pathname")
    mock_children = [ mock("Dir1"), mock("Dir2"), mock("Dir3")]
    mock_children_basenames = ["Dir1.Basename", "Dir2.Basename", "Dir3.Basename"]
    mock_script_3 = mock("script3")
  
    File.should_receive(:dirname).with(any_args()).and_return(mock_cwd)
    Pathname.should_receive(:new).with(mock_cwd).and_return(mock_cwd_pathname) 
    mock_cwd_pathname.should_receive(:children).and_return(mock_children)
    mock_children[0].should_receive(:directory?).and_return(true)    
    mock_children[1].should_receive(:directory?).and_return(true)    
    mock_children[2].should_receive(:directory?).and_return(true)    

    mock_children[0].should_receive(:basename).and_return(mock_children_basenames[0])    
    Kernel.should_receive(:require).with("Dir1.Basename/dir1.basename").and_raise("can't require")

    mock_children[1].should_receive(:basename).and_return(mock_children_basenames[1])    
    Kernel.should_receive(:require).with("Dir2.Basename/dir2.basename")
    Kernel.should_receive(:eval).with("Dir2.Basename.new").and_raise("can't create")
    Kernel.should_receive(:puts).with("Problem loading Dir1.Basename geeklet.").ordered

    mock_children[2].should_receive(:basename).and_return(mock_children_basenames[2])    
    Kernel.should_receive(:require).with("Dir3.Basename/dir3.basename")
    Kernel.should_receive(:eval).with("Dir3.Basename.new").and_return(mock_script_3)
    Kernel.should_receive(:puts).with("Problem loading Dir2.Basename geeklet.").ordered
  
    geeklets = Geeklets.new
  end

end

describe Geeklets do
  
  before(:all) { @geeklets = Geeklets.new }
  
  subject { @geeklets }
  
  it { should respond_to :show_usage }
  it { should respond_to :show_known_scripts }
  it { should respond_to :run }
end

describe Geeklets do
    
    context :initialize, "when there are no scripts" do
      include GeekletExampleHelperMethods
  
      before(:each) { @geeklets = mock_no_scripts }
  
      it "should produce an empty list" do
        Kernel.should_receive(:puts).with("These are the currently known geeklet scripts:").ordered
        Kernel.should_receive(:puts).with(no_args()).ordered
        Kernel.should_receive(:puts).with("There are no defined geeklet scripts.").ordered
        Kernel.should_receive(:puts).with(no_args()).ordered

        @geeklets.show_known_scripts
      end
    end
  
    context :initialize, "when there are scripts with no problems" do
      include GeekletExampleHelperMethods

      before(:each) { @geeklets = mock_some_scripts_no_problems }

      it "should not produce an empty list" do
        Kernel.should_receive(:puts).with("These are the currently known geeklet scripts:").ordered
        Kernel.should_receive(:puts).with(no_args()).ordered
        Kernel.should_receive(:puts).with("\tDir1.Basename").ordered
        Kernel.should_receive(:puts).with("\tDir2.Basename").ordered
        Kernel.should_receive(:puts).with("\tDir3.Basename").ordered
        Kernel.should_receive(:puts).with(no_args()).ordered

        @geeklets.show_known_scripts
      end
    end

    context :initialize, "when there are scripts with problems" do
      include GeekletExampleHelperMethods

      before(:each) { @geeklets = mock_some_scripts_with_problems }

      it "should skip the scripts with problems and report them" do
        Kernel.should_receive(:puts).with("These are the currently known geeklet scripts:").ordered
        Kernel.should_receive(:puts).with(no_args()).ordered
        Kernel.should_receive(:puts).with("\tDir3.Basename").ordered
        Kernel.should_receive(:puts).with(no_args()).ordered

        @geeklets.show_known_scripts
      end
    end

end

describe Geeklets do
  
  before { @geeklets = Geeklets.new }
    
  subject { @geeklets.run }  
    
  context "when given no parameters" do
    
    it "should show usage and available scripts" do
      @geeklets.should_receive(:show_usage)
      @geeklets.should_receive(:show_known_scripts)
    
      @geeklets.run(nil)
    end
  
  end

  context "when given empty parameters" do
    
    it "should show usage and available scripts" do
      @geeklets.should_receive(:show_usage)
      @geeklets.should_receive(:show_known_scripts)
    
      @geeklets.run([])
    end
  
  end

  context "when given parmeters for a non existant script" do
    
    it "should indicate that it doesn't understand, and show the available scripts" do
      Kernel.should_receive(:puts).with("I do not know how to run the noscript geeklet.").ordered
      @geeklets.should_receive(:show_known_scripts)
    
      @geeklets.run(["noscript"])
    end
  
  end

  context "when given parmeters for an existing script" do
    
    before do 
      @script_hash = mock("script hash") 
      @script_hash.should_receive(:empty?).and_return(false)
      @geeklets = Geeklets.new(@script_hash)
    end
    
    it "should attempt to run that script" do
      @script_hash.should_receive(:include?).with("some_script").and_return(true)
      @script_hash.should_receive(:[]).with("some_script").and_return(mock_script = mock("some_script"))
      mock_script.should_receive(:run).with(["some_params"])
    
      @geeklets.run(["some_script", "some_params"])
    end
  
  end
end
