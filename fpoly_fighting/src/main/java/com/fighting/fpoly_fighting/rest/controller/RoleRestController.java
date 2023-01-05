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

import com.fighting.fpoly_fighting.entity.Role;
import com.fighting.fpoly_fighting.service.RoleService;

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/roles" )
public class RoleRestController {

	@Autowired
	RoleService roleService ;
	
	@GetMapping()
	public List< Role > getAll() {
		try {
			return roleService.findAll() ;
		} catch( Exception ex ) {
			return null ;
		}
	}
	
	@PutMapping( "{id}" )
	public ResponseEntity< Role > update( @RequestBody Role role , @PathVariable( "id" ) Long id ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( roleService.update( role ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
}
