package com.fighting.fpoly_fighting.service;

import java.util.List;

import com.fighting.fpoly_fighting.entity.Favorite;

public interface FavoriteService {
	
	List< Long > findByCustomerId( Long customerId ) ;

	Favorite findByCustomerIdAndProductId( Long customerId , Long productId ) ;

	Favorite create( Favorite favorite ) ;

	Favorite update( Favorite favorite ) ;

	List< Favorite > findAll() ;

	List<Favorite> findAllIsCanceledFalse() ;
	
}
