require 'nokogiri'
require 'open-uri'

url = "http://www.cbssports.com/nfl/scoreboard"
data = Nokogiri::HTML(open(url))
teams = data.css('.teamName')

puts teams.at_css('.teamLocation').text
