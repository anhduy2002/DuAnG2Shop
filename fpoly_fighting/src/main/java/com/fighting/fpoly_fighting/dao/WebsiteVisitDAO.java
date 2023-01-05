package com.fighting.fpoly_fighting.dao;

import java.time.LocalDate;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.fighting.fpoly_fighting.entity.WebsiteVisit;

@Repository
public interface WebsiteVisitDAO extends JpaRepository< WebsiteVisit , Long > {
	WebsiteVisit findByDate(LocalDate date);
}
