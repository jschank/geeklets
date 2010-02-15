# coding: UTF-8
require 'rubygems'
require 'chronic'
require 'mechanize'

FEED_URL = "http://www.vre.org/service/daily-download.html"
TRAIN_LINES = {"fbg_delay" => :fredericksburg, "mss_delay" => :manassas}

class VRE_Alerts

  def wrap(s, width=78)
    s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
  end

  def die
    puts <<-EOS
    vre-alert

    USAGE:

    \tvre-alert [rail_lines] [wrapping-width] [specific-date]

    Returns Virgina Railway Express (VRE) Alerts.

    [rail_lines] specifies which rail lines you want alerts for.
    Can be:
    \tfredericsburg - for the Fredericsburg line
    \tmanassas      - for the Manassas line
    \tboth          - for both lines.
    Defaults to: both
  
    [wrapping-width] is an integer to limit the width of the descriptions
    Defaults to: 40
  
    [specific-date] is a string parseable by Date::parse which is the date from
    the VRE daily download to display. NOTE: this does not access history, it only
    allows you to choose a specific entry from the Daily Download to render. Mostly
    used for debugging.
    Defaults to: The current system Date.

  EOS

    exit
  end

  # >> notice.search("tr")[2].search("td")[0].attributes["class"].value
  # => "fbg2"
  # >> notice.search("tr")[2].search("td")[0].text
  # => "Train 300"
  def parse_notice(notice)
    detail = {}
    detail[:summary] = notice.attributes["summary"].text
    detail[:morning] = []
    detail[:evening] = []
    rows = notice.search("tr")
    service = nil

    rows.each do |row|
      cells = row.search("td")
      case cells.count
      when 0 : 
        (detail[:date] = Date.parse(row.children[0].text)) if (row && row.children && row.children[0] && row.children[0].name == "th")
      when 1 :
        service = :morning if row.children[0].text =~ /Morning/
        service = :evening if row.children[0].text =~ /Evening/
      when 2 :
        # sometimes they split a description across multiple rows, when they do, they leave the train cell blank
        # in that case, append the description text to the last trains description.
        if cells[0].text.empty? && detail[service][-1]
          detail[service][-1][:description] << cells[1].text
          next 
        end
      
        cell_class = cells[0].attributes["class"].value unless cells[0].text.empty?
        detail[service] << {:line => TRAIN_LINES[cell_class], :train => cells[0].text, :description => cells[1].text} if @rail_lines == :both || @rail_lines == TRAIN_LINES[cell_class]
      else
        next
      end
    end
    detail
  end

  def render_trains(trains, width)
    puts "  No delays" and return if trains.empty?
    trains.each do |train|
      puts "  #{train[:line].to_s.capitalize} line #{train[:train]}"
      wrap(train[:description], width).each{|str| puts "    #{str}"}
    end
  end

  def render_notice(notice, width)
    if (notice.nil? || (notice[:morning].empty? && notice[:evening].empty?))
      puts "No VRE notices for today"
      return 
    end

    puts notice[:summary]
    puts "#{'-' * notice[:summary].length}"
    puts "Morning Service"
    render_trains(notice[:morning], width)
    puts
    puts "Afternoon/Evening Service"
    render_trains(notice[:evening], width)
  end

  def run(params)
    die if params[0] == "-h"

    @rail_lines = (params[0] || "both").to_sym
    width = (params[1] and params[1].to_i) || 40
    alert_date = (params[2] and Date.parse(params[2])) || Date.today

    #debug - set a date of interest, and rail line of interest
    # alert_date = Date.civil(2010, 1, 13)
    # @rail_lines = :fredericksburg

    agent = WWW::Mechanize.new
    agent.get(FEED_URL)
    notices = agent.page.search(".format").map{ |notice| parse_notice(notice) }

    #debug
    #puts notices.to_yaml

    render_notice(notices.select{ |notice| notice[:date] == alert_date }.shift, width)
  end

end
