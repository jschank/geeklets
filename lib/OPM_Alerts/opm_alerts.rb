# coding: UTF-8
require 'rubygems'
require 'open-uri'
require 'nokogiri'

class OPM_Alerts < Geeklet
  registerConfiguration :OPM_Alerts, :URL, :default => "http://www.opm.gov/status/index.aspx", :description => "OPM website URL", :type => :string
  registerConfiguration :OPM_Alerts, :width, :default => 40, :description => "Word wrap width", :type => :int

  def description
    "Returns U.S. Office of Personnel Management status Alerts."
  end

  def run(params)
    super(:OPM_Alerts, params)
    
    doc = Nokogiri::HTML(open(configurableValue(:OPM_Alerts, :URL)))

    date_str = doc.css('#_ctl0__ctl0_DisplayDateSpan').text.strip
    begin
      date = Date.parse(date_str)
      date_str = date.strftime("%x")
    rescue
      date_str = Date.today.strftime("%x") if date_str.length == 0
    end

    title = doc.css('h3').text.strip
    title = "VRE Status" if title.length == 0

    status = doc.css('.statusbox').text.strip

    # Deal with the flaky case where OPM decides to
    # display an image instead of actual text content
    images = doc.xpath("//img")
    status = images[0].attributes["alt"].text.strip if ((status.length == 0) && (images.count == 1))

    status = "Not found" if status.length == 0

    # display results
    width = configurableValue(:OPM_Alerts, :width)
    puts Utility.wrap_text("#{date_str} - #{title}", width, date_str.length + 3, :outdent)
    puts "-" * width
    puts Utility.wrap_text(status, width)
  end

end