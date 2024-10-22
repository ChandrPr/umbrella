require "dotenv/load"
require "http"
require "json"
require "awesome_print"

puts "Enter your location!"
#user_input = gets.chomp
user_input = "chicago"
puts "Checking the weather at #{user_input}...."

gmap_raw_resp = HTTP.get(
    "https://maps.googleapis.com/maps/api/geocode/json",
    {
      :params => {
        "address" => user_input,
        "key" => ENV.fetch("GMAPS_KEY"),
      },
    }
  )
gmap_json = JSON.parse(gmap_raw_resp)["results"][0]
latitude = gmap_json["geometry"]["location"]["lat"]
longitude = gmap_json["geometry"]["location"]["lng"]
puts "Your coordinates are #{latitude}, #{longitude}."

PIRATE_WEATHER_KEY = ENV.fetch("PIRATE_WEATHER_KEY")
weather_raw_resp = HTTP.get(
    "https://api.pirateweather.net/forecast/#{PIRATE_WEATHER_KEY}/#{latitude},#{longitude}",
)
weather_json = JSON.parse(weather_raw_resp)
pp weather_json.keys

#puts "It is currently #{curtemp}."
