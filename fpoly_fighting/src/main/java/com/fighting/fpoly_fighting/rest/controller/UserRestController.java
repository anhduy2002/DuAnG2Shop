package com.fighting.fpoly_fighting.rest.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fighting.fpoly_fighting.entity.User;
import com.fighting.fpoly_fighting.service.SessionService;
import com.fighting.fpoly_fighting.service.UserService;

@RestController
@RequestMapping( "/rest/users" )
public class UserRestController {
	
	@Autowired
	UserService userService;
	
	@Autowired
	SessionService sessionService ;
	
	@GetMapping()
	public List< User > getAll() {
		return userService.findAll() ;
	}
	
	@GetMapping( "{id}" )
	public User getOne( 
			@PathVariable( "id" ) Long id 
		) {
		return userService.findById( id ) ;
	}

}
