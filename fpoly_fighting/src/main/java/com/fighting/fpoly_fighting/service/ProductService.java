package com.fighting.fpoly_fighting.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.fighting.fpoly_fighting.entity.Product;

public interface ProductService {
    
    List<Product> findAll();
    
    Product findSlug(String slug);
    
    List<Product> findByCategorySlug( String slug ) ;

	Page<Product> findByRelatedProduct( Long productId , Long categoryId , Pageable pageable );

	Page<Product> findByFilter( 
			Long[] filter_categories ,
			Long[] filter_brands ,
			boolean isFilterCategoriesEnabled ,
			boolean isFilterBrandsEnable ,
			Long likedCustomerId ,
			Long boughtCustomerId ,
			int min ,
			int max ,
			String search , 
			Pageable pageable
	) ;
	
	Product findById( Long id ) ;

	List<Product> findAll( Pageable pageable ) ;

	Product create( Product product ) throws Exception ;

	Product update( Product product ) throws Exception ;

	void delete( Long id ) throws Exception ;
	
	List< Long > findAllProductIds() ;

	void increaseViewCount( Long id ) throws Exception ;

	List<Product> findAllByOrderByLikesCountDesc() ;

	List<Product> findByCategoryId( Long categoryId ) ;

}
