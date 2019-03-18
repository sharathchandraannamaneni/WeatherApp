package com.openweather.util;

import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class RestUtil {
    private RestTemplate template = new RestTemplate();
    private String openweathermap = "http://api.openweathermap.org/data/2.5/weather?q=";
    private String appId = "0dd675cd1799eb6794d6464dd3d060ad";

    public JSONObject getWeatherData(String query) {
        ResponseEntity<String> jsonResponse = template.getForEntity(openweathermap + query + "&appid=" + appId,
                String.class);
        System.out.println(jsonResponse);
        JSONObject json = new JSONObject(jsonResponse.getBody());
        return json;
    }
}
