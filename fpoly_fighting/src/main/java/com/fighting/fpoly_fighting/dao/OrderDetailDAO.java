package com.fighting.fpoly_fighting.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.fighting.fpoly_fighting.entity.OrderDetail;

@Repository
public interface OrderDetailDAO extends JpaRepository<OrderDetail, Long> {

	@Query( value = "SELECT p FROM OrderDetail p WHERE p.order.id = :orderId" )
	List< OrderDetail > findByOrderId( Long orderId ) ;

}
