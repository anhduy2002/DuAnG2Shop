package com.fighting.fpoly_fighting.service;

import java.util.List;

import com.fighting.fpoly_fighting.entity.User;

public interface StaffService {
	
	List< User > findAll() ;

	User update( User staff ) throws Exception ;

	User create( User staff ) throws Exception ;

	User findById( Long id ) ;

	User getLoggedInStaff() ;

	void deleteByLoggedInStaff( Long id ) throws Exception ;
	
}
