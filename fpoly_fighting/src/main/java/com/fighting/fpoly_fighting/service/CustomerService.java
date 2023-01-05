package com.fighting.fpoly_fighting.service;

import java.util.List;

import com.fighting.fpoly_fighting.entity.User;

public interface CustomerService {
	
	List< User > findAll() ;

	User update( User customer ) throws Exception ;
	
	User findById( Long id ) ;

	User signUp( User customer ) ;

	User getLoggedInCustomer() ;
	
}
