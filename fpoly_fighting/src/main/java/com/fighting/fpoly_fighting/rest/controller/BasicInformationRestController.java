package com.fighting.fpoly_fighting.rest.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fighting.fpoly_fighting.entity.BasicInformation;
import com.fighting.fpoly_fighting.service.BasicInformationService;
import com.fighting.fpoly_fighting.service.SessionService;

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/basic-information" )
public class BasicInformationRestController {

	@Autowired
	BasicInformationService basicInformationService ;
	
	@Autowired
	SessionService sessionService ;
	
	@GetMapping()
	public BasicInformation getBasicInformation() {
		try {
			return basicInformationService.findById(1L) ;
		} catch( Exception ex ) {
			return null ;
		}
	}
	
	@PutMapping()
	public ResponseEntity< BasicInformation > update( @RequestBody BasicInformation basicInformation ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( basicInformationService.update( basicInformation ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
}
