require 'rubygems'
require 'mechanize'
require 'rio'

class Get_Weather_Icon

  @URL = "http://weather.yahoo.com/forecast/USVA0262.html"

  def run(params)
    agent = WWW::Mechanize.new
    agent.get(@URL)
    icon = agent.page.at(".forecast-icon")
    style = icon.attributes["style"].value
    icon_url = style.split("'")[1]

    rio(icon_url) > rio("/tmp/weather-icon.png")
  end

end