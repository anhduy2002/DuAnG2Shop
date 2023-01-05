package com.fighting.fpoly_fighting.interceptor;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.fighting.fpoly_fighting.entity.BasicInformation;
import com.fighting.fpoly_fighting.entity.Cart;
import com.fighting.fpoly_fighting.service.BasicInformationService;
import com.fighting.fpoly_fighting.service.SessionService;
import com.fighting.fpoly_fighting.service.WebsiteVisitService;

@Service
public class GlobalInterceptor implements HandlerInterceptor{
	
	@Autowired 
	SessionService sessionService ;
	
	@Autowired
	BasicInformationService basicInformationService;
	
	@Autowired
	WebsiteVisitService websiteVisitService;
	
	@Override
	public boolean preHandle(	HttpServletRequest req , HttpServletResponse res , Object handler ) throws Exception {
		if( sessionService.get( "cart" ) == null ) {
			sessionService.set( "cart" , new Cart() ) ;
		} 
		if( sessionService.get( "viewedProductIdList" ) == null ) {
			sessionService.set( "viewedProductIdList" , new ArrayList< Long >() ) ;
		} 
		if( sessionService.get( "isNewWebsiteVisit" ) == null ) {
			websiteVisitService.increaseVisitCount( java.time.LocalDate.now() ) ;
			sessionService.set( "isNewWebsiteVisit" , true ) ;
		}
		req.setAttribute( "uri" , req.getRequestURI() ) ;
		
		BasicInformation basicInformation = basicInformationService.findById(1L);
		req.setAttribute("basicInformation", basicInformation);
		return true;
	}

}
