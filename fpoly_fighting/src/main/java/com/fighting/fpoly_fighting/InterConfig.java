package com.fighting.fpoly_fighting;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.fighting.fpoly_fighting.interceptor.GlobalInterceptor;

@Configuration
public class InterConfig implements WebMvcConfigurer {
	
	@Autowired
	GlobalInterceptor global ;
	
	@Override
	public void addInterceptors( InterceptorRegistry registry ) {
		registry.addInterceptor( global ).addPathPatterns( "/**" ) ;
	}
	
}
