require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'configurable'

describe Configurable do
  
  before do
    klass = Class.new do
      include Configurable
    end
    @configurable = klass.new
  end
  
  describe :configurableValue do

    context "when group not registered" do      
      it "should throw an exception" do
        lambda { @configurable.configurableValue("no_group", "someUnregisteredKey") }.should raise_exception(UnregisteredConfigValueError)
      end      
    end
    
    context "when group is registered but configurable value not registered" do      
      it "should throw an exception" do
        @configurable.registerConfiguration("group", "someRegisteredKey")
        lambda { @configurable.configurableValue("group", "someUnregisteredKey") }.should raise_exception(UnregisteredConfigValueError)
      end      
    end
    
    context "when configurable value is registered" do
    
      context "with a default value" do
        it "should return the default value" do
          @configurable.registerConfiguration("group", "someRegisteredKey", :default => "some Default Value")
          @configurable.configurableValue("group", "someRegisteredKey").should == "some Default Value"
        end
      end

      context "without a default value" do
        it "should indicate that configuration is necessary" do
          @configurable.registerConfiguration("group", "someRegisteredKey")
          lambda { @configurable.configurableValue("group", "someRegisteredKey") }.should raise_exception(ConfigurationRequiredError)
        end
      end
      
      context "when value is overridden" do
        it "should return the overridden value" do
           @configurable.registerConfiguration("group", "someRegisteredKey", :default => "default", :type => :string)
           @configurable.add_overrides("group", ["-s", "override"])
           @configurable.configurableValue("group", "someRegisteredKey").should == "override"
        end
      end

    end
    
    
    
  end
  
  describe :isHelp do
    
    it "should return true when param is 'help'" do
      help = ['Help', 'help', "HeLp"]      
      help.each { |param| @configurable.isHelp?(param).should be_true }
    end
    
    it "should be false when the param is not 'help'" do
      not_help = [2, nil, ""]
      not_help.each { |param| @configurable.isHelp?(param).should be_false }
    end
    
  end

end
