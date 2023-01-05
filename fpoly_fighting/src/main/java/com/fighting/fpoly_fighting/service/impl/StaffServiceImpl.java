package com.fighting.fpoly_fighting.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.configuration.EncoderConfig;
import com.fighting.fpoly_fighting.dao.UserDAO;
import com.fighting.fpoly_fighting.entity.User;
import com.fighting.fpoly_fighting.service.SessionService;
import com.fighting.fpoly_fighting.service.StaffService;
import com.fighting.fpoly_fighting.service.UserService;
@Service
public class StaffServiceImpl implements StaffService{
	
	@Autowired
	UserDAO userDao ;
	
	@Autowired
	SessionService sessionService ;
	
	@Autowired
	UserService userService ;
	
	@Autowired
	EncoderConfig encoderConfig;

	@Override
	public List< User > findAll() {
		return userDao.findAllStaff() ;
	}

	@Override
	public User update( User staff ) throws Exception {
		final User _staff = userDao.findById( staff.getId() ).get() ;
		if( _staff.getId() != null && this.findById( _staff.getId() ) == null ) throw new Exception( "Mã nhân viên không tồn tại!" ) ;
		_staff.setEmail( staff.getEmail() ) ;
		_staff.setRole( staff.getRole() ) ;
		_staff.setIsEnabled( staff.getIsEnabled() ) ;
		_staff.setIsDeleted( staff.getIsDeleted() ) ;
		return userDao.save( _staff ) ;
	}
	
	@Override
	public User create( User staff ) throws Exception {
		if( staff.getId() != null && this.findById( staff.getId() ) != null ) throw new Exception( "Mã nhân viên đã được sử dụng!" ) ;
		staff.setCreatedDate( new Date() ) ;
		staff.setHashPassword( encoderConfig.passwordEncoder().encode( "123" ) ) ;
		return userDao.save( staff ) ;
	}

	@Override
	public void deleteByLoggedInStaff( Long id ) throws Exception {
		if( id != null && this.findById( id ) == null ) throw new Exception( "Mã nhân viên không tồn tại!" ) ;
		final User staff = this.findById( id ) ;
		if( !staff.getIsDeleted() ) throw new Exception( "Không được xóa nhân viên khi chưa cập nhật isDeleted!" ) ;
		final User loggedInStaff = this.getLoggedInStaff() ;
		if( id.equals( loggedInStaff.getId() ) ) throw new Exception( "Bạn không được tự xóa chính mình!" ) ;
		userDao.deleteById( id ) ;
	}

	@Override
	public User findById( Long id ) {
		return userDao.findById( id ).get() ;
	}
	
	@Override
	public User getLoggedInStaff() {
		final User user = userService.getLoggedInUser() ;
		if( user == null ) return null ;
		if( user.getRole().getId() < 2L ) return null ;
		return userService.getLoggedInUser() ;
	}
	
}
