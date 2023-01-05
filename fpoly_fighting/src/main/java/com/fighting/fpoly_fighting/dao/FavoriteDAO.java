package com.fighting.fpoly_fighting.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.fighting.fpoly_fighting.entity.Favorite;

@Repository
public interface FavoriteDAO extends JpaRepository<Favorite, Long> {

	@Query( value = "SELECT p.product.id FROM Favorite p WHERE p.customer.id = :customerId AND p.isCanceled IS FALSE" )
	List< Long > findByCustomerId( Long customerId ) ;

	@Query( value = "SELECT p FROM Favorite p WHERE p.customer.id = :customerId AND p.product.id = :productId" )
	Favorite findByCustomerIdAndProductId( Long customerId, Long productId ) ;

	@Query( value = "SELECT p FROM Favorite p WHERE p.isCanceled IS FALSE" )
	List< Favorite > findAllIsCanceledFalse() ;

}
