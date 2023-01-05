package com.fighting.fpoly_fighting.rest.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fighting.fpoly_fighting.entity.User;
import com.fighting.fpoly_fighting.service.SessionService;
import com.fighting.fpoly_fighting.service.StaffService;

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/staffs" )
public class StaffRestController {

	@Autowired
	StaffService staffService ;
	
	@Autowired
	SessionService sessionService ;
	
	@GetMapping()
	public List< User > getAll() {
		try {
			return staffService.findAll() ;
		} catch( Exception ex ) {
			return null ;
		}
	}
	
	@GetMapping( "logged-in" )
	public User getLoggedinStaff() {
		return staffService.getLoggedInStaff() ;
	}
	
	@PostMapping()
	public ResponseEntity< User > create( @RequestBody User staff ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( staffService.create( staff ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
	@PutMapping( "{id}" )
	public ResponseEntity< User > update( @RequestBody User staff , @PathVariable( "id" ) Long id ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( staffService.update( staff ) ) ;
		} catch( Exception ex ) {
			System.out.println( ex.toString() ) ;
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
	@DeleteMapping( "{id}" )
	public ResponseEntity< User > delete( @PathVariable( "id" ) Long id ) {
		try {
			staffService.deleteByLoggedInStaff( id ) ;
			return ResponseEntity.status( HttpStatus.OK ).build() ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
}
