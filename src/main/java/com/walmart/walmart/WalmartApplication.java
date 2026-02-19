package com.walmart.walmart;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = "com.walmart.walmart")
public class WalmartApplication {

	public static void main(String[] args) {
		SpringApplication.run(WalmartApplication.class, args);
	}

}
