require "dotenv/load"
require "http"
require "json"

puts "Enter your location!"
user_input = gets.chomp
#user_input = "chicago"
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

weather_raw_resp = HTTP.get(
    "https://api.pirateweather.net/forecast/#{ENV.fetch("PIRATE_WEATHER_KEY")}/#{latitude},#{longitude}",
)
weather_json = JSON.parse(weather_raw_resp)
puts "It is currently #{weather_json['currently']['temperature']}°F."
puts "Next hour: #{weather_json['minutely']['summary']}"

umbrella = false
weather_json['hourly']['data'][1..12].each do |hourlyData|
  precipProb = hourlyData['precipProbability'] * 100
  if precipProb >= 10
    umbrella = true
    hoursFromNow = (hourlyData['time'] - Time.now) / 60.0 / 60.0
    puts "There is a #{precipProb.round}% chance of rain #{hoursFromNow.round} hours from now."
  end
end

if umbrella
  puts "You may want to take an umbrella!"
else
  puts "You should not require an umbrella."
end
