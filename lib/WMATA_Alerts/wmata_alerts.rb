# coding: UTF-8
require 'rubygems'
require 'rss'
require 'open-uri'
require 'chronic'
require 'htmlentities'

REPLACEMENTS = 
[
  ["p.m.", "pm"], 
  ["a.m.", "am"]
]

FEED_URL = "http://www.wmata.com/rider_tools/metro_service_status/feeds/rail.xml"

class WMATA_Alerts

  def wrap(s, width=78)
    s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
  end

  def die
    puts <<-EOS
  metro-feed

    USAGE:

    \tmetro-feed [history] [wrapping-width]

    Returns WMATA feed information for metro lines.

    [history] is how many days of feed history to display.
    \tdefaults to 7 days. Can be anything parseable by Chronic gem

    [wrapping-width] is the limit to how wide the text can be
    \tdefaults to 40 characters. should be a positive integer value.

    Requires gems: chronic, htmlentities


  EOS

    exit
  end

  def run(params)

    die if params[0] == "-h"

    @cutoff_string = params[0] || "7 days ago"
    @width = params[1] || "40"
    @width = @width.to_s.to_i

    @cutoff = Chronic.parse(@cutoff_string)

    @rss_content = ""

    open(FEED_URL) do |f|
      @rss_content = f.read
    end

    @rss = RSS::Parser.parse(@rss_content, false)

    @item_hash = {}

    # filter down to the items we want.
    @rss.items.each do |item|
      @item_hash[item.pubDate] = item unless item.pubDate < @cutoff
    end

    if @item_hash.empty?
      puts "No data from WMATA feed."
    else
      @coder = HTMLEntities.new
      @item_hash.keys.sort.reverse.each do |key|
        item = @item_hash[key]

        title = "#{item.pubDate.strftime('%x')} - #{item.title}"
        puts title
        puts ("-" * title.length)

        message = @coder.decode(item.description)
        REPLACEMENTS.each do |r|
          message = message.gsub(r[0], r[1])
        end
        subject, *body = message.split(".")

        puts wrap(subject+".", @width)
        body.each do |sentence|
          chunks = wrap(sentence, @width).split("\n")
          chunks[-1] = chunks[-1] + "."
          chunks.each do |chunk|
            puts "  " + chunk.strip
          end
        end  

        puts
      end
    end
  
  end


end