package com.fighting.fpoly_fighting;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class FpolyFightingApplication {

	public static void main(String[] args) {
		SpringApplication.run(FpolyFightingApplication.class, args);
	}

}
