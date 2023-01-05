package com.fighting.fpoly_fighting.service;

import java.util.List;

import com.fighting.fpoly_fighting.entity.Category;

public interface CategoryService {
	
	List<Category> findAll();

	Category findBySlug( String categorySlug ) ;

	Category findById( Long id ) ;

	Category create( Category category ) throws Exception ;

	Category update( Category category ) throws Exception ;

	void delete( Long id ) throws Exception ;
	
}
