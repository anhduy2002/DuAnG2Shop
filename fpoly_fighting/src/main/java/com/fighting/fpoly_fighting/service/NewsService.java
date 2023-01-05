package com.fighting.fpoly_fighting.service;

import java.util.List;

import com.fighting.fpoly_fighting.entity.News;

public interface NewsService {
	
	List< News > findAll();

	News findById( Long id ) ;

	News create( News news ) throws Exception ;

	News update( News news ) throws Exception ;

	void delete( Long id ) throws Exception ;

	List< News > findByIsShowedOnHomepageTrueAndIsDeletedFalse() ;
	
	List< News > findByIsDeletedFalse() ;
	
}
