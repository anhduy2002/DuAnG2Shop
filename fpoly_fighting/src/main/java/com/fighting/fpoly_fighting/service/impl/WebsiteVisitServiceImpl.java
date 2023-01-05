package com.fighting.fpoly_fighting.service.impl;

import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.dao.WebsiteVisitDAO;
import com.fighting.fpoly_fighting.entity.WebsiteVisit;
import com.fighting.fpoly_fighting.service.WebsiteVisitService;

@Service
public class WebsiteVisitServiceImpl implements WebsiteVisitService {

	@Autowired
	WebsiteVisitDAO websiteVisitDAO ;

	@Override
	public WebsiteVisit findById( Long id ) {
		return websiteVisitDAO.findById( id ).get() ;
	}

	@Override
	public WebsiteVisit findByDate( LocalDate date ) {
		return websiteVisitDAO.findByDate( date );
	}
	
	@Override
	public void increaseVisitCount( LocalDate date ) {
		if( this.findByDate( date ) == null ){
			WebsiteVisit websiteVisit = new WebsiteVisit() ;
			websiteVisit.setDate( date ) ;
			websiteVisit.setVisitCount( 1 ) ;
			websiteVisitDAO.save( websiteVisit ) ;
			return;
		}
		WebsiteVisit websiteVisit = this.findByDate( date ) ;
		websiteVisit.setVisitCount( websiteVisit.getVisitCount() + 1 ) ;
		websiteVisitDAO.save( websiteVisit ) ;
	}

}
