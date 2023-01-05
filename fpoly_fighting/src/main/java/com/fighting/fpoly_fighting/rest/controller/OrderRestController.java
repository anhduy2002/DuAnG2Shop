package com.fighting.fpoly_fighting.rest.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fighting.fpoly_fighting.entity.Order;
import com.fighting.fpoly_fighting.service.OrderService;

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/orders" )
public class OrderRestController {

	@Autowired
	OrderService orderService ;
	
	@GetMapping()
	public List< Order > getAll( 
			@RequestParam( name = "orderStatusId" ) Optional< Integer > _orderStatusId ,
			@RequestParam( name = "shippingStaffId" ) Optional< Long > _shippingStaffId ,
			@RequestParam( name = "orderStatusIds" ) Optional< Integer[] > _orderStatusIds
		) {
		try {
			if( _orderStatusId.isPresent() ) return orderService.findAllByOrderStatusId( _orderStatusId.get() ) ;
			if( _shippingStaffId.isPresent() && _orderStatusIds.isPresent() ) return orderService.findAllByShippingStaffIdAndOrderStatusIds( _shippingStaffId.get() , _orderStatusIds.get() ) ;
			return orderService.findAll() ;
		} catch ( Exception ex ) {
			return null ;
		}
	}
	
	@PutMapping( "{id}" )
	public ResponseEntity< Order > update( 
			@RequestParam( name = "orderStatusId" ) Integer orderStatusId ,
			@RequestParam( name = "shippingFee" ) Optional< Double > _shippingFee ,
			@PathVariable( "id" ) Long id 
		) {
		final Double shippingFee = _shippingFee.isPresent() ? _shippingFee.get() : null ;
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( orderService.updateByLoggedInStaff( id , orderStatusId , shippingFee ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}
	
	@GetMapping( "downloadBill/{id}" )
	public ResponseEntity< Boolean > update( 
			@PathVariable( "id" ) Long id 
		) {
		try {
			return ResponseEntity.status( HttpStatus.OK ).body( orderService.downloadBill( id ) ) ;
		} catch( Exception ex ) {
			return ResponseEntity.status( HttpStatus.BAD_REQUEST ).build() ;
		}
	}

}
