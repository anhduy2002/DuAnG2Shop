package com.fighting.fpoly_fighting.service;

import java.util.List;

import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;

import com.fighting.fpoly_fighting.entity.User;

public interface UserService {

	List< User > findAll() ;
	
	User findById( Long id ) ;
	
	User findByUsername( String username ) ;
	
	User findByEmail( String email ) ;
	
	void updateAccount( User user ) ;
	
	User update( User user ) ;

	void setLoggedInUserByUsername( String username ) ;

	void removeLoggedInUser() ;

	void setLoggedInUserByOAuth2AuthenticationToken( OAuth2AuthenticationToken oauth2AuthenticationToken ) throws Exception ;

	User create( User user ) throws Exception ;

	void setLoggedInUser( User user ) ;

	void updatePassword( User user , String newPassword ) throws Exception ;

	User getLoggedInUser() ;

	User findByResetPasswordCode( String _resetPasswordCode ) ;

}
