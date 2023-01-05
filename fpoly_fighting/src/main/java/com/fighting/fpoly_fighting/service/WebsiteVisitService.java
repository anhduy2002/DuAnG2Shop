package com.fighting.fpoly_fighting.service;

import java.time.LocalDate;

import com.fighting.fpoly_fighting.entity.WebsiteVisit;

public interface WebsiteVisitService {

	WebsiteVisit findById(Long id);
	WebsiteVisit findByDate( LocalDate date );
	void increaseVisitCount( LocalDate date );
}
