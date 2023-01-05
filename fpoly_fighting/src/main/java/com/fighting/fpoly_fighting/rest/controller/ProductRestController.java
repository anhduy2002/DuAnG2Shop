package com.fighting.fpoly_fighting.rest.controller;

import java.util.List;
import java.util.Optional;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fighting.fpoly_fighting.entity.Product;
import com.fighting.fpoly_fighting.service.ProductService;

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/products" )
public class ProductRestController {

	@Autowired
	ProductService productService ;
	
	@GetMapping()
	public List< Product > getAll(
			@RequestParam( name = "categoryId" ) Optional< Long > _categoryId
		) {
		try {
			if( _categoryId.isPresent() ) return productService.findByCategoryId( _categoryId.get() ) ;
			return productService.findAll() ;
		} catch( Exception ex ) {
			return null ;
		}
	}
	
	@GetMapping("/favorite-product")
	public List< Product > getAllByOrderByLikesCount() {
		try {
			return productService.findAllByOrderByLikesCountDesc() ;
		} catch( Exception ex ) {
			return null ;
		}
	}
	
	@PostMapping()
	public ResponseEntity< Product > create( @RequestBody Product product ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( productService.create( product ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
	@PutMapping( "{id}" )
	public ResponseEntity< Product > update( @RequestBody Product product , @PathVariable( "id" ) Long id ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( productService.update( product ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
	@DeleteMapping( "{id}" )
	public ResponseEntity< Product >  delete( @PathVariable( "id" ) Long id ) {
		try {
			productService.delete( id ) ;
			return ResponseEntity.status( HttpStatus.OK ).build() ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
	@GetMapping( "allProductIds" )
	public List< Long > getAllProductIds() {
		try {
			return productService.findAllProductIds() ;
		} catch( Exception ex ) {
			return null ;
		}
		
	}
	
}
