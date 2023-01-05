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

import com.fighting.fpoly_fighting.entity.Category;
import com.fighting.fpoly_fighting.service.CategoryService;

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/categories" )
public class CategoryRestController {

	@Autowired
	CategoryService categoryService ;
	
	@GetMapping()
	public List< Category > getAll() {
		try {
			return categoryService.findAll() ;
		} catch( Exception ex ) {
			return null ;
		}
	}
	
	@PostMapping()
	public ResponseEntity< Category > create( @RequestBody Category category ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( categoryService.create( category ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
	@PutMapping( "{id}" )
	public ResponseEntity< Category > update( @RequestBody Category category , @PathVariable( "id" ) Long id ) {
		try {
			
			return ResponseEntity.status( HttpStatus.OK ).body( categoryService.update( category ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
	@DeleteMapping( "{id}" )
	public ResponseEntity< Category >  delete( @PathVariable( "id" ) Long id ) {
		try {
			categoryService.delete( id ) ;
			return ResponseEntity.status( HttpStatus.OK ).build() ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
}
