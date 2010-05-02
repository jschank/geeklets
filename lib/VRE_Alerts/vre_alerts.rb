# coding: UTF-8
require 'rubygems'
require 'chronic'
require 'mechanize'

class VRE_Alerts < Geeklet
  registerConfiguration :VRE_Alerts, :URL, :default => "http://www.vre.org/service/daily-download.html", :description => "VRE website URL", :type => :string
  registerConfiguration :VRE_Alerts, :lines, :default => "both", :description => "Which rail line. (manassas, fredericksburg, or both)", :type => :string
  registerConfiguration :VRE_Alerts, :width, :default => 40, :description => "Wrapping width", :type => :int
  registerConfiguration :VRE_Alerts, :date, :default => "today", :description => "A string parseable by Date::parse which is the date from the VRE daily download to display. NOTE: this does not access history, it only allows you to choose a specific entry from the Daily Download to render.", :type => :string
  
  def name
    "VRE_Alerts"
  end
  
  def description
    "Returns Virgina Railway Express (VRE) Alerts."
  end
  
  def line(cell_class)
    case cell_class
    when "fbg_delay" then :fredericksburg
    when "mss_delay" then :manassas
    end
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
        rail_lines = configurableValue(:VRE_Alerts, :lines).to_sym
        detail[service] << {:line => line(cell_class), :train => cells[0].text, :description => cells[1].text} if rail_lines == :both || rail_lines == line(cell_class)
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
      puts Utility.wrap_text(train[:description], width, 3, :all)
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
    super(:VRE_Alerts, params)

    agent = Mechanize.new
    agent.get(configurableValue(:VRE_Alerts, :URL))
    notices = agent.page.search(".format").map{ |notice| parse_notice(notice) }

    #debug
    #puts notices.to_yaml

    width = configurableValue(:VRE_Alerts, :width)
    alert_date = configurableValue(:VRE_Alerts, :date)
    render_notice(notices.select{ |notice| notice[:date] == alert_date }.shift, width)
  end

end
