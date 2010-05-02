# coding: UTF-8
require 'rubygems'
require 'rss'
require 'open-uri'
require 'chronic'
require 'htmlentities'

class WMATA_Alerts < Geeklet
  registerConfiguration :WMATA_Alerts, :URL, :default => "http://www.wmata.com/rider_tools/metro_service_status/feeds/rail.xml", :description => "WMATA website URL", :type => :string
  registerConfiguration :WMATA_Alerts, :width, :default => 40, :description => "Wrapping width", :type => :int
  registerConfiguration :WMATA_Alerts, :history, :default => "7 days ago", :description => "how many days of feed history to display. Can be anything parseable by Chronic gem.", :type => :string

  def name
    "WMATA_Alerts"
  end
  
  def description
    "Returns WMATA feed information for metro lines."
  end
  
  def translate(message)
    [
      ["p.m.", "pm"], 
      ["a.m.", "am"]
    ].each { |r| message.gsub!(r[0], r[1]) }
    message
  end
  
  def run(params)
    super(:WMATA_Alerts, params)

    rss_content = ""

    open(configurableValue(:WMATA_Alerts, :URL)) do |f|
      rss_content = f.read
    end

    rss = RSS::Parser.parse(rss_content, false)

    item_hash = {}

    # filter down to the items we want.
    rss.items.each do |item|
      item_hash[item.pubDate] = item unless item.pubDate < Chronic.parse(configurableValue(:WMATA_Alerts, :history))
    end

    if item_hash.empty?
      puts "No data from WMATA feed."
    else
      coder = HTMLEntities.new
      item_hash.keys.sort.reverse.each do |key|
        item = item_hash[key]

        title = "#{item.pubDate.strftime('%x')} - #{item.title}"
        puts title
        puts ("-" * title.length)

        message = coder.decode(item.description)
        message = translate(message)
        subject, *body = message.split(".")
        
        width = configurableValue(:WMATA_Alerts, :width)
        puts Utility.wrap_text(subject + "...", width)
        body.each do |sentence|
          puts Utility.wrap_text(sentence + ".", width, 3, :all)
        end

        puts
      end
    end
  
  end


end