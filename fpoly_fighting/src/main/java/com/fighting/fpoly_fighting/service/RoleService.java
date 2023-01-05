package com.fighting.fpoly_fighting.service;

import java.util.List;

import com.fighting.fpoly_fighting.entity.Role;

public interface RoleService {
	
	Role findByName( String name ) ;

	List < Role > findAll() ;

	Role update( Role role ) throws Exception ;

	Role findById( Long id ) ;
	
}
