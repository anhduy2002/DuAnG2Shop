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

import com.fighting.fpoly_fighting.entity.News;
import com.fighting.fpoly_fighting.service.NewsService;

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/news" )
public class NewsRestController {

	@Autowired
	NewsService newsService ;
	
	@GetMapping()
	public List< News > getAll() {
		try {
			return newsService.findAll() ;
		} catch( Exception ex ) {
			return null ;
		}
	}
	
	@PostMapping()
	public ResponseEntity< News > create( @RequestBody News news ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( newsService.create( news ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
	@PutMapping( "{id}" )
	public ResponseEntity< News > update( @RequestBody News category , @PathVariable( "id" ) Long id ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( newsService.update( category ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
	@DeleteMapping( "{id}" )
	public ResponseEntity< News >  delete( @PathVariable( "id" ) Long id ) {
		try {
			newsService.delete( id ) ;
			return ResponseEntity.status( HttpStatus.OK ).build() ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
}
