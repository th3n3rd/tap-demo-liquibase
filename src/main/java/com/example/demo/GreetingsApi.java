package com.example.demo;

import java.util.List;
import java.util.Random;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
class GreetingsApi {

    private final GreetingsRepository greetingsRepository;

    @GetMapping("/")
    public Greeting greet() {
        var greetings = greetingsRepository.findAll();
        return greetings.get(randomIndexIn(greetings));
    }

    private int randomIndexIn(List<Greeting> greetings) {
        return new Random().nextInt(greetings.size());
    }

}
