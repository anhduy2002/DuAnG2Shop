package com.fighting.fpoly_fighting.rest.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fighting.fpoly_fighting.entity.OrderDetail;
import com.fighting.fpoly_fighting.service.OrderDetailService;

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/order-details" )
public class OrderDetailRestController {

	@Autowired
	OrderDetailService orderDetailService ;
	
	@GetMapping( "/by-order-id/{orderId}" )
	public List< OrderDetail > getAllByOrderId( 
			@PathVariable( "orderId" ) Long orderId 
		) {
		try {
			return orderDetailService.findByOrderId( orderId ) ;
		} catch( Exception ex ) {
			return null ;
		}
	}

}
