package com.example.demo;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Data;

@Data
@Entity(name = "greetings")
class Greeting {
    @Id
    private Long id;

    private String message;

    private String language;
}
