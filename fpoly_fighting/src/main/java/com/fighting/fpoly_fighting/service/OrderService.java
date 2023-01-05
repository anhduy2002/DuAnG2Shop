package com.fighting.fpoly_fighting.service;

import java.util.List;

import org.springframework.data.domain.Sort;

import com.fighting.fpoly_fighting.entity.Cart;
import com.fighting.fpoly_fighting.entity.Order;
import com.fighting.fpoly_fighting.entity.OrderInfo;
import com.fighting.fpoly_fighting.entity.User;

public interface OrderService {
	
	 List< Order > findAll() ;
	 
	 List< Order > findByCustomerId( Long customerId, Sort sort ) ;

	 void order( User user, Cart cart , OrderInfo orderInfo ) ;

	 Order findById( Long orderId ) ;

	 boolean cancel( Long orderId, User user ) ;

	 List< Order > findAllByOrderStatusId( Integer id ) ;

	 Order update( Order order ) throws Exception ;

	 Long countByOrderStatusIdAndShippinngStaffId( Integer orderStatusId, Long shippingStaffId ) ;
	 
	Order updateByLoggedInStaff( Long id , Integer orderStatusId , Double ShippingFee ) throws Exception ;

	List<Order> findAllByShippingStaffIdAndOrderStatusIds( Long shippingStaffId , Integer[] orderStatusIds ) ;

	Boolean downloadBill( Long id ) ;

	 
}
