package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class GreetingsApi {

    @GetMapping("/")
    public String greet() {
        return "Hello World!";
    }

}
