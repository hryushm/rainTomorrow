require 'json'
require 'open-uri'

BASE_URL = "http://api.openweathermap.org/data/2.5/forecast"

def isTomorrow(unix_time)
    day = Time.at(unix_time).day
    Time.now.day + 1 == day
end

def is6or9am(unix_time)
    time = Time.at(unix_time).hour
    time == 6 || time == 9
end

def rainTomorrow?(city)
    response = open(BASE_URL + "?q=#{city}&units=metric&APPID=#{ENV['API_KEY']}")
    res =  JSON.parse(response.read)
    res['list'].each do |li|
        if isTomorrow(li['dt']) && is6or9am(li['dt'])
            min = li['main']['temp_min']
            max = li['main']['temp_max']
            weather = li['weather'][0]['main']
            if weather == 'Rain'
                return true
            end
        end
    end
    return false
end

puts '明日の朝は雨が降るから気をつけて！' if rainTomorrow?('Tokyo')
