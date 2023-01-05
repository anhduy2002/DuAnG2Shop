package com.fighting.fpoly_fighting.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.dao.OrderDetailDAO;
import com.fighting.fpoly_fighting.entity.OrderDetail;
import com.fighting.fpoly_fighting.service.OrderDetailService;

@Service
public class OrderDetailServiceImpl implements OrderDetailService {
	
	@Autowired
	OrderDetailDAO orderDetailDao;

	@Override
	public OrderDetail create( OrderDetail orderDetail ) {
		return orderDetailDao.save( orderDetail ) ;
	}

	@Override
	public List< OrderDetail > findByOrderId( Long orderId ) {
		return orderDetailDao.findByOrderId( orderId ) ;
	}

}
