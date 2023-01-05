package com.fighting.fpoly_fighting.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.dao.FavoriteDAO;
import com.fighting.fpoly_fighting.entity.Favorite;
import com.fighting.fpoly_fighting.service.FavoriteService;

@Service
public class FavoriteServiceImpl implements FavoriteService {

	@Autowired
	FavoriteDAO favoriteDao ;
	
	@Override
	public List< Long > findByCustomerId( Long customerId ) {
		return favoriteDao.findByCustomerId( customerId ) ;
	}

	@Override
	public Favorite findByCustomerIdAndProductId( Long customerId, Long productId ) {
		return favoriteDao.findByCustomerIdAndProductId( customerId , productId ) ;
	}

	@Override
	public Favorite create( Favorite favorite ) {
		return favoriteDao.save( favorite ) ;
	}

	@Override
	public Favorite update( Favorite favorite ) {
		return favoriteDao.save( favorite ) ;
	}

	@Override
	public List< Favorite > findAll() {
		return favoriteDao.findAll() ;
	}
	
	@Override
	public List< Favorite > findAllIsCanceledFalse() {
		return favoriteDao.findAllIsCanceledFalse() ;
	}

}
