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

import com.fighting.fpoly_fighting.entity.OrderStatus;
import com.fighting.fpoly_fighting.service.OrderStatusService;

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/order-statuses" )
public class OrderStatusRestController {

	@Autowired
	OrderStatusService orderStatusService ;
	
	@GetMapping()
	public List< OrderStatus > getAll() {
		try {
			return orderStatusService.findAll() ;
		} catch( Exception ex ) {
			return null ;
		}
	}
	
	@PutMapping( "{id}" )
	public ResponseEntity< OrderStatus >  update( @RequestBody OrderStatus orderStatus , @PathVariable( "id" ) Long id ) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( orderStatusService.update( orderStatus ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}

}
