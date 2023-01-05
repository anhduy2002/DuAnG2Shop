package com.fighting.fpoly_fighting.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.configuration.EncoderConfig;
import com.fighting.fpoly_fighting.dao.UserDAO;
import com.fighting.fpoly_fighting.entity.Role;
import com.fighting.fpoly_fighting.entity.User;
import com.fighting.fpoly_fighting.service.RoleService;
import com.fighting.fpoly_fighting.service.SessionService;
import com.fighting.fpoly_fighting.service.UserService;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	UserDAO userDao ;
	
	@Autowired
	SessionService sessionService ;

	@Autowired
	RoleService roleService ;
	
	@Autowired
	EncoderConfig encoderConfig ;
	
	@Override
	public User findByUsername( String username ) {
		return userDao.findByUsername( username ) ;
	}
	
	@Override
	public User findByEmail( String email ) {
		return userDao.findByEmail( email ) ;
	}
	
	private User findByPhone( String phone ) {
		return userDao.findByPhone( phone ) ;
	}
	
	@Override
	public User findByResetPasswordCode( String resetPasswordCode ) {
		return userDao.findByResetPasswordCode( resetPasswordCode ) ;
	}
	
	@Override
	public void setLoggedInUserByUsername( String username ) {
		this.setLoggedInUser( this.findByUsername( username ) ) ;
	}
	
	@Override
	public void setLoggedInUser( User user ) {
		sessionService.set( "USER" , user ) ;
	}
	
	@Override
	public void removeLoggedInUser() {
		sessionService.remove( "USER" ) ;
	}
	
	@Override
	public void updateAccount( User user ) {
		final User _user = userDao.findById( user.getId() ).get() ;
		_user.setUsername( user.getUsername() ) ;
		_user.setFullname( user.getFullname() ) ;
		_user.setEmail( user.getEmail() ) ;
		_user.setPhone( user.getPhone() ) ;
		_user.setAddress( user.getAddress() ) ;
		userDao.save( _user ) ;
	}

	@Override
	public void updatePassword( User user , String newPassword ) throws Exception {
		if( newPassword.length() < 3 ) throw new Exception( "Mật khẩu phải có ít nhất 3 ký tự!" ) ; /* trả về ngoại lệ với thông báo - Kết thúc phương thức */
		final String hashPassword = encoderConfig.passwordEncoder().encode( newPassword ) ; /* passwordEncoder của  encoderConfig để mã hóa*/ /*  */
		user.setHashPassword( hashPassword ) ;
		this.update( user ) ; 
	}

	@Override
	public User update( User user ){
		return userDao.save( user ) ;
	}
	
	@Override
	public User create( User user ) throws Exception{
		if( user.getId() != null && userDao.findById( user.getId() ).isPresent() ) {
			throw new Exception( "Tạo mới người dùng thất bại. Mã người dùng đã được sử dụng." ) ;
		}
		return userDao.save( user ) ;
	}

	@Override
	public User findById( Long id ) {
		return userDao.findById( id ).get() ;
	}

	@Override
	public List<User> findAll() {
		return userDao.findAll() ;
	}

	@Override
	public void setLoggedInUserByOAuth2AuthenticationToken( OAuth2AuthenticationToken oauth2AuthenticationToken ) throws Exception {
		final Map< String , Object > attributes = oauth2AuthenticationToken.getPrincipal().getAttributes() ;
		final String email = ( String ) attributes.get( "email" ) ;
		final User user = this.findByEmail( email ) ;
		if( user != null ) {
			final UserDetails _user =  org.springframework.security.core.userdetails.User.withUsername( email ).password( user.getHashPassword() ).roles( String.valueOf( user.getRole().getId() ) ).build() ;
			final Authentication auth = new UsernamePasswordAuthenticationToken( _user , null , _user.getAuthorities() ) ;
			SecurityContextHolder.getContext().setAuthentication( auth ) ;
			this.setLoggedInUser( user ) ;
			return ;
		}
		final User customer = new User() ;
		customer.setUsername( email ) ;
		customer.setCreatedDate( new Date() ) ;
		customer.setEmail( email ) ;
		final String name = ( String ) attributes.get( "name" ) ;
		customer.setFullname( name.length() > 50 ? name.substring( 0 , 50 ) : name ) ;
		final String hashPassword = encoderConfig.passwordEncoder().encode( "123" ) ;
		customer.setHashPassword( encoderConfig.passwordEncoder().encode( hashPassword ) ) ;
		customer.setIsDeleted( false ) ;
		customer.setIsEnabled( true ) ;
		final Role role = roleService.findById( 1L ) ;
		customer.setRole( role ) ;
		boolean check = false ;
		String phone = "" ;
		while( !check ) {
			final long randomNum = ThreadLocalRandom.current().nextLong( 1000000l , 9999999l ) ;
			phone = "000" + String.valueOf( randomNum ) ;
			final User _user = this.findByPhone( phone ) ;
			if( _user == null ) check = true ;
		}
		customer.setPhone( phone ) ;
		customer.setAddress( "#####" ) ;
		this.create( customer ) ;
		final UserDetails _user =  org.springframework.security.core.userdetails.User.withUsername( email ).password( hashPassword ).roles( String.valueOf( role.getId() ) ).build() ;
		final Authentication auth = new UsernamePasswordAuthenticationToken( _user , null , _user.getAuthorities() ) ;
		SecurityContextHolder.getContext().setAuthentication( auth ) ;
		this.setLoggedInUser( customer ) ;
	}

	@Override
	public User getLoggedInUser() {
		return sessionService.get( "USER" ) ;
	}

}
