package com.fighting.fpoly_fighting.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.fighting.fpoly_fighting.entity.Brand;

public interface BrandService {
	
	List< Brand > findAll() ;
	
	Page< Brand > findAll( Pageable pageable ) ;

	Page<Brand> findBest( Pageable pageable ) ;
	
	Brand findById( Long id ) ;

	Brand create( Brand category ) throws Exception ;

	Brand update( Brand category ) throws Exception ;

	void delete( Long id ) throws Exception ;

}
