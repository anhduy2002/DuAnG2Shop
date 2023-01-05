package com.fighting.fpoly_fighting.dao;

import java.util.List;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.fighting.fpoly_fighting.entity.Order;

@Repository
public interface OrderDAO extends JpaRepository<Order, Long> {

	@Query( value = "SELECT p FROM Order p WHERE p.customer.id = :customerId" )
	List< Order > findByCustomerId( Long customerId, Sort sort ) ;
	
	@Query( value = "SELECT p FROM Order p ORDER BY p.createdDate DESC" )
	List< Order > findAllSortByCreatedDate() ;

	@Query( value = "SELECT p FROM Order p WHERE p.orderStatus.id = :id" )
	List< Order > findByOrderStatusId( Integer id ) ;
	
	@Query( value = "SELECT count( p ) FROM Order p WHERE p.orderStatus.id = :orderStatusId AND p.shippingStaff.id = :shippingStaffId" )
	Long countByOrderStatusIdAndShippinngStaffId( Integer orderStatusId , Long shippingStaffId ) ;

	@Query( value = "SELECT p FROM Order p WHERE p.shippingStaff.id = :shippingStaffId AND p.orderStatus.id IN :orderStatusIds" )
	List< Order > findAllByShippingStaffIdAndOrderStatusIds( Long shippingStaffId , Integer[] orderStatusIds ) ;

}
