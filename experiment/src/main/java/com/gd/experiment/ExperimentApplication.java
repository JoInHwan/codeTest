package com.gd.experiment;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@EnableScheduling
@SpringBootApplication
public class ExperimentApplication implements WebMvcConfigurer{

	public static void main(String[] args) {
		SpringApplication.run(ExperimentApplication.class, args);
	}

}
