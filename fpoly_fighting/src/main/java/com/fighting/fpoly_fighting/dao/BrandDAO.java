package com.fighting.fpoly_fighting.dao;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.fighting.fpoly_fighting.entity.Brand;

@Repository
public interface BrandDAO extends JpaRepository<Brand, Long> {
	
	@Query( value = "SELECT p FROM Brand p" )
	Page< Brand > findAll( Pageable pageable ) ;

	@Query( value = "Select b FROM Brand b, Product p, OrderDetail d , Order o WHERE o.id = d.order.id AND d.product.id = p.id AND b.id = p.brand.id AND p.brand.name != 'Khác' AND o.orderStatus.id > 0 GROUP BY b.id , b.name , b.slug , b.imageName , b.isDeleted ORDER BY SUM( d.quantity ) DESC" )
	//@Query( value = "Select b FROM Brand b, Product p WHERE b.id = p.brand.id GROUP BY b , b.name , b.slug , b.imageName , b.isDeleted" )
	Page<Brand> findBest( Pageable pageable ) ;
	
}
