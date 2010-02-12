#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'rio'

@URL = "http://weather.yahoo.com/forecast/USVA0262.html"

agent = WWW::Mechanize.new
agent.get(@URL)
icon = agent.page.at(".forecast-icon")
style = icon.attributes["style"].value
icon_url = style.split("'")[1]

rio(icon_url) > rio("/tmp/weather-icon.png")
