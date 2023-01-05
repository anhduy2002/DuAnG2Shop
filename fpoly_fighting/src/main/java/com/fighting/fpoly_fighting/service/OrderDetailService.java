package com.fighting.fpoly_fighting.service;

import java.util.List;

import com.fighting.fpoly_fighting.entity.OrderDetail;

public interface OrderDetailService {

	OrderDetail create( OrderDetail orderDetail ) ;

	List< OrderDetail > findByOrderId( Long orderId ) ;

}
