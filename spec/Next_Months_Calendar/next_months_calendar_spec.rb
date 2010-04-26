require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'Next_Months_Calendar/next_months_calendar'

describe Next_Months_Calendar do

  before { @script = Next_Months_Calendar.new }
  
  subject { @script }

  describe "In general" do
    it { should be_a_kind_of(Geeklet)}
  end

  describe :run do
    
    context "when this month is April" do
      it "should get the calendar for next month" do
        Date.should_receive(:today).and_return(Date.civil(2010, 4, 26))        
        Kernel.should_receive(:system).with("cal","5","2010")      
        @script.run([])
      end
    end

    context "when this month is December" do
      it "should get the calendar for next month, in the next year" do
        Date.should_receive(:today).and_return(Date.civil(2010, 12, 25))
        Kernel.should_receive(:system).with("cal","1","2011")
        @script.run([])
      end
    end

    context "when the following month has fewer days" do
      it "should get the calendar for next month, in the next year" do
        Date.should_receive(:today).and_return(Date.civil(2010, 1, 31))
        Kernel.should_receive(:system).with("cal","2","2010")
        @script.run([])
      end
    end

  end
end