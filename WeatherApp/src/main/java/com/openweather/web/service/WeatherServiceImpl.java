package com.openweather.web.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;

import com.openweather.exception.WeatherNotFoundException;
import com.openweather.model.Weather;
import com.openweather.util.RestUtil;

@Service
public class WeatherServiceImpl implements WeatherService {
    private Logger LOG = Logger.getLogger(WeatherServiceImpl.class);
    @Autowired
    private RestUtil util;

    @Override
    public List<Weather> getWeather(String[] input) {
        LOG.info("Entered getWeather with city : " + Arrays.toString(input));
        List<Weather> weatherList = new ArrayList<>();
        try {
            Arrays.stream(input).forEach(in -> {
                String query = in.trim();
                JSONObject json = util.getWeatherData(query);

                JSONArray jsonArray = json.getJSONArray("weather");
                Weather weather = new Weather();
                weather.setName(json.getString("name"));
                weather.setCountry(json.getJSONObject("sys").getString("country"));
                if (jsonArray.length() > 0) {
                    weather.setDescription(((JSONObject) jsonArray.get(0)).getString("description"));
                }
                JSONObject main = json.getJSONObject("main");
                weather.setTemp(main.getInt("temp"));
                weather.setPressure(main.getInt("pressure"));
                weather.setHumidity(main.getInt("humidity"));
                weather.setTemp_min(main.getInt("temp_min"));
                weather.setTemp_max(main.getInt("temp_max"));
                weatherList.add(weather);
            });
        } catch (final HttpClientErrorException e) {
            throw new WeatherNotFoundException("City not found");
        } catch (final Exception e) {
            throw new WeatherNotFoundException(e.getMessage());
        }
        return weatherList;
    }
}
