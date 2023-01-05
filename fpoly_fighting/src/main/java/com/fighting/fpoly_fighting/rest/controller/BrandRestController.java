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

import com.fighting.fpoly_fighting.entity.Brand;
import com.fighting.fpoly_fighting.service.BrandService;

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/brands" )
public class BrandRestController {

	@Autowired
	BrandService brandService ;
	
	@GetMapping()
	public List< Brand > getAll() {
		try {
			return brandService.findAll() ;
		} catch( Exception ex ) {
			return null ;
		}
	}
	
	@PostMapping()
	public ResponseEntity< Brand > create( @RequestBody Brand brand ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( brandService.create( brand ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
	@PutMapping( "{id}" )
	public ResponseEntity< Brand > update( @RequestBody Brand brand , @PathVariable( "id" ) Long id ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( brandService.update( brand ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
	@DeleteMapping( "{id}" )
	public ResponseEntity< Brand > delete( @PathVariable( "id" ) Long id ) {
		try {
			brandService.delete( id ) ;
			return ResponseEntity.status( HttpStatus.OK ).build() ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
}
