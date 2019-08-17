package com.github.gasrios.localops;

import java.io.IOException;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class Hello {

	public static void main(String[] args) {
		SpringApplication.run(Hello.class, args);
	}

	@RequestMapping(method = RequestMethod.GET, value  = "/")
	public ResponseEntity<String> root() throws IOException {
		return new ResponseEntity<String>("Hello world!", HttpStatus.OK);
	}

}
