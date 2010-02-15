# coding: UTF-8
require 'rubygems'
require 'open-uri'
require 'nokogiri'

URL = "http://www.opm.gov/status/index.aspx"

class OPM_Alerts

  def wrap(s, width=78)
    s.strip.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
  end

  def die
    puts <<-EOS
  opm-status

  USAGE:

  \topm-status [wrapping-width]

  Returns U.S. Office of Personnel Management status Alerts.

  [wrapping-width] is an integer to limit the width of the descriptions
  Defaults to: 40

EOS

    exit
  end

  def run(params)
    die if params[0] == "-h"

    width = (params[1] and params[1].to_i) || 40

    doc = Nokogiri::HTML(open(URL))

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
    puts "#{date_str} - #{title}"
    puts "-" * width
    puts wrap(status, width)
  end

end