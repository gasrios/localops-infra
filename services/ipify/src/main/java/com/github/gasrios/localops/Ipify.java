package com.github.gasrios.localops;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/*
 * Use this to test your pods have access to external resources.
 */
@SpringBootApplication
@RestController
public class Ipify {

	public static void main(String[] args) {
		SpringApplication.run(Ipify.class, args);
	}

	@RequestMapping(method = RequestMethod.GET, value  = "/")
	public ResponseEntity<String> root() throws IOException {

		HttpURLConnection connection = (HttpURLConnection) new URL("https://api.ipify.org?format=json").openConnection();

		if (connection.getResponseCode() != 200)
			return new ResponseEntity<String>(HttpStatus.valueOf(connection.getResponseCode()));

		BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));

		StringBuffer buffer = new StringBuffer();
		String line;
		while ((line = in.readLine()) != null) buffer.append(line);

		in.close();
		connection.disconnect();

		return new ResponseEntity<String>(buffer.toString(), HttpStatus.valueOf(connection.getResponseCode()));

	}

}