package com.fighting.fpoly_fighting.rest.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fighting.fpoly_fighting.entity.User;
import com.fighting.fpoly_fighting.service.CustomerService;
import com.fighting.fpoly_fighting.service.SessionService;

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/customers" )
public class CustomerRestController {

	@Autowired
	CustomerService customerService ;
	
	@Autowired
	SessionService sessionService ;
	
	@GetMapping()
	public List< User > getAll() {
		try {
			return customerService.findAll() ;
		} catch( Exception ex ) {
			return null ;
		}
	}
	
	@PutMapping( "{id}" )
	public ResponseEntity< User > update( @RequestBody User customer , @PathVariable( "id" ) Long id ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( customerService.update( customer ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
}
