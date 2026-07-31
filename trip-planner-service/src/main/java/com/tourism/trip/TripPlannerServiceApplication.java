package com.tourism.trip;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableFeignClients
public class TripPlannerServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(TripPlannerServiceApplication.class, args);
    }
}
