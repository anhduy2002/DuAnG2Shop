package com.fighting.fpoly_fighting;

import java.util.NoSuchElementException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.fighting.fpoly_fighting.configuration.EncoderConfig;
import com.fighting.fpoly_fighting.service.UserService;

@SuppressWarnings( "deprecation" )
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter{
	
	@Autowired
	UserService userService ;
	
	@Autowired
	EncoderConfig encoderConfig;
	
	protected void configure( AuthenticationManagerBuilder auth ) throws Exception {
		auth.userDetailsService( username -> {
			try {
				final com.fighting.fpoly_fighting.entity.User user = userService.findByUsername( username ) ;
				final String password = user.getHashPassword() ;
				final String role = String.valueOf( user.getRole().getId() ) ;
				return User.withUsername( username ).password( password ).roles( role ).build() ;
			} catch( NoSuchElementException ex ) {
				throw new UsernameNotFoundException( username + " not found!" ) ;
			}
		} ) ;
	}
	
	@Override
	protected void configure( HttpSecurity http ) throws Exception {
		
		//CSRF, CORS
		http.csrf().disable().cors().disable() ;
		
		http.authorizeRequests()
			.antMatchers( "/nguoi-dung/**" ).authenticated()
			.antMatchers( "/khach-hang/**" ).hasAuthority( "ROLE_1" )
			.antMatchers( "/rest/**" ).hasAnyAuthority( "ROLE_2" , "ROLE_3" , "ROLE_4" )
			.antMatchers( "/admins/**" ).hasAnyAuthority( "ROLE_2" , "ROLE_3" , "ROLE_4" )
			.anyRequest().permitAll() ;
		
		http.formLogin()
			.loginPage( "/dang-nhap" )
			.loginProcessingUrl( "/dang-nhap" )
			.defaultSuccessUrl( "/dang-nhap?isSuccessful=true" , true )
			.failureUrl( "/dang-nhap?isSuccessful=false" ) ;
		
		http.rememberMe()
			.rememberMeParameter( "remember-me" )
			.tokenValiditySeconds( 86400 ) ;
		
		http.logout()
			.logoutUrl( "/nguoi-dung/dang-xuat" )
			.logoutSuccessUrl( "/dang-nhap?isLoggedOut=true" ) ;
		
		//Đăng nhập từ mạng xã hội
		http.oauth2Login()
			.loginPage( "/dang-nhap" )
			.defaultSuccessUrl( "/oauth2/login/success" , true )
			.failureUrl( "/dang-nhap/that-bai" )
			.authorizationEndpoint()
			.baseUri( "/dang-nhap-tu-mxh" ) ;
	}
	
	@Override
	public void configure( WebSecurity web ) throws Exception{
		web.ignoring().antMatchers( HttpMethod.OPTIONS , "/**" ) ;
	}
	
}
