package com.fighting.fpoly_fighting.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.dao.OrderStatusDAO;
import com.fighting.fpoly_fighting.entity.OrderStatus;
import com.fighting.fpoly_fighting.service.OrderStatusService;

@Service
public class OrderStatusServiceImpl implements OrderStatusService {

	@Autowired
	OrderStatusDAO orderStatusDao;
	
	@Override
	public OrderStatus findById( Integer id ) {
		return orderStatusDao.findById( id ).get() ;
	}

	@Override
	public List< OrderStatus > findAll() {
		return orderStatusDao.findAll() ;
	}

	@Override
	public OrderStatus update( OrderStatus orderStatus ) throws Exception {
		if( orderStatus.getId() != null && this.findById( orderStatus.getId() ) == null ) throw new Exception( "Mã trạng thái đơn hàng không tồn tại!" ) ;
		return orderStatusDao.save( orderStatus ) ;
	}

}
