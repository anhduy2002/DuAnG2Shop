package com.fighting.fpoly_fighting.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.dao.RoleDAO;
import com.fighting.fpoly_fighting.entity.Role;
import com.fighting.fpoly_fighting.service.RoleService;

@Service
public class RoleServiceImpl implements RoleService {

	@Autowired
	private RoleDAO roleDao;
	
	@Override
	public Role findByName( String name ) {
		return roleDao.findByName( name );
	}
	
	@Override
	public Role findById( Long id ) {
		return roleDao.findById( id ).get() ;
	}

	@Override
	public List< Role > findAll() {
		return roleDao.findAll() ;
	}

	@Override
	public Role update( Role role ) throws Exception {
		if( role.getId() != null && this.findById( role.getId() ) == null ) throw new Exception( "Mã vai trò không tồn tại!" ) ;
		return roleDao.save( role ) ;
	}
	
}
