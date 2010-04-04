require 'rubygems'
require 'mechanize'
require 'rio'

class Get_Weather_Icon

  def run(params)
    agent = Mechanize.new
    agent.get("http://weather.yahoo.com/forecast/USVA0262.html")
    icon = agent.page.at(".forecast-icon")
    style = icon.attributes["style"].value
    icon_url = style.split("'")[1]

    rio(icon_url) > rio("/tmp/weather-icon.png")
  end

end