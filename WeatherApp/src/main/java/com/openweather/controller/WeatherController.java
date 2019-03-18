package com.openweather.controller;

import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.openweather.model.Weather;
import com.openweather.web.service.WeatherService;

@RestController
public class WeatherController {
    private Logger LOG = Logger.getLogger(WeatherController.class);
    @Autowired
    private WeatherService service;

    @RequestMapping(value = "/search")
    public List<Weather> getSearchResultViaAjax(@RequestParam String city) {
        LOG.info("Entered WeatherController with input : " + city);
        String[] cities = city.split(",");
        cities = Arrays.stream(cities).distinct().toArray(String[]::new);
        LOG.debug("Unique cities are : " + Arrays.toString(cities));
        List<Weather> list = service.getWeather(cities);
        LOG.info("Return from WeatherController with output size : " + list.size());
        return list;
    }

}