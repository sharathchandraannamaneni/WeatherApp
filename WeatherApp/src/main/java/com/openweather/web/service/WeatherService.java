package com.openweather.web.service;

import java.util.List;

import com.openweather.model.Weather;

public interface WeatherService {

    List<Weather> getWeather(String[] cities);

}
