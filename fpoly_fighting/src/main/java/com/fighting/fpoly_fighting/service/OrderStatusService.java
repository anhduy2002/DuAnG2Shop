package com.fighting.fpoly_fighting.service;

import java.util.List;

import com.fighting.fpoly_fighting.entity.OrderStatus;

public interface OrderStatusService {
	
	OrderStatus findById( Integer id ) ;
	
	List < OrderStatus > findAll() ;
	
	OrderStatus update( OrderStatus orderStatus ) throws Exception ;
	
}
