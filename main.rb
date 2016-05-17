require 'json'
require 'open-uri'

BASE_URL = "http://api.openweathermap.org/data/2.5/forecast"
API_KEY = File.open(File.dirname(__FILE__) + "/apikey").read

def isTomorrow(unix_time)
    day = Time.at(unix_time).day
    Time.now.day + 1 == day
end

def is6or9am(unix_time)
    time = Time.at(unix_time).hour
    time == 6 || time == 9
end

def getWeather(city)
    response = open(BASE_URL + "?q=#{city}&units=metric&APPID=#{API_KEY}")
    JSON.parse(response.read)
end

def rainTomorrow?(city)
    res = getWeather(city)
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

def getWeather69(city)
    res = getWeather(city)
    arr = Array.new
    res['list'].each do |li|
        if isTomorrow(li['dt']) && is6or9am(li['dt'])
            arr.push(li['weather'][0]['description'])
        end
    end
    return arr
end
