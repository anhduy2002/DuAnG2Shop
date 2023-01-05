package com.fighting.fpoly_fighting.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.configuration.EncoderConfig;
import com.fighting.fpoly_fighting.dao.UserDAO;
import com.fighting.fpoly_fighting.entity.Role;
import com.fighting.fpoly_fighting.entity.User;
import com.fighting.fpoly_fighting.service.CustomerService;
import com.fighting.fpoly_fighting.service.RoleService;
import com.fighting.fpoly_fighting.service.SessionService;
import com.fighting.fpoly_fighting.service.UserService;
@Service
public class CustomerServiceImpl implements CustomerService{
	
	@Autowired
	UserDAO userDao ;
	
	@Autowired
	SessionService sessionService ;
	
	@Autowired
	UserService userService ;
	
	@Autowired
	RoleService roleService ;
	
	@Autowired
	EncoderConfig encoderConfig ;

	@Override
	public List< User > findAll() {
		return userDao.findAllCustomer() ;
	}

	@Override
	public User update( User customer ) throws Exception {
		final User _customer = userDao.findById( customer.getId() ).get() ;
		if( _customer.getId() != null && this.findById( _customer.getId() ) == null ) throw new Exception( "Mã khách hàng không tồn tại!" ) ;
		_customer.setIsEnabled( customer.getIsEnabled() ) ;
		_customer.setIsDeleted( customer.getIsDeleted() ) ;
		return userDao.save( _customer ) ;
	}

	@Override
	public User findById( Long id ) {
		return userDao.findById( id ).get() ;
	}
	
	@Override
	public User signUp( User customer ){
		final Role role = roleService.findById( 1L ) ;
		customer.setRole( role ) ;
		customer.setCreatedDate( new Date() ) ;
		customer.setHashPassword( encoderConfig.passwordEncoder().encode( customer.getHashPassword() ) ) ;
		customer.setIsDeleted( false ) ;
		customer.setIsEnabled( true ) ;
		return userDao.save( customer ) ;
	}

	@Override
	public User getLoggedInCustomer() {
		final User user = userService.getLoggedInUser() ;
		if( user == null ) return null ;
		if( user.getRole().getId() != 1L ) return null ;
		return user ;
	}
	
}
