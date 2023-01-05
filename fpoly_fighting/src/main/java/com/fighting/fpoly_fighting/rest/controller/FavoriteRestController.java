package com.fighting.fpoly_fighting.rest.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fighting.fpoly_fighting.entity.Favorite;
import com.fighting.fpoly_fighting.service.FavoriteService;

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/favorites" )
public class FavoriteRestController {

	@Autowired
	FavoriteService favoriteService ;
	
	@GetMapping()
	public List< Favorite > getAll(
			@RequestParam( name = "isCanceled" ) Optional< Boolean > _isCanceled
			) {
		if( _isCanceled.isPresent() && !_isCanceled.get() ) {
			try {
				return favoriteService.findAllIsCanceledFalse() ;
			} catch( Exception ex ) {
				return null ;
			}
		}
		try {
			return favoriteService.findAll() ;
		} catch( Exception ex ) {
			return null ;
		}
	}
	
}
