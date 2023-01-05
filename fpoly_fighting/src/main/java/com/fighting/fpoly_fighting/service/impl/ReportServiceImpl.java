package com.fighting.fpoly_fighting.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.dao.ReportDAO;
import com.fighting.fpoly_fighting.entity.Report1A;
import com.fighting.fpoly_fighting.entity.Report1B;
import com.fighting.fpoly_fighting.entity.Report2A;
import com.fighting.fpoly_fighting.entity.Report2B;
import com.fighting.fpoly_fighting.entity.Report2C;
import com.fighting.fpoly_fighting.entity.Report2D;
import com.fighting.fpoly_fighting.entity.Report2E;
import com.fighting.fpoly_fighting.entity.Report3A;
import com.fighting.fpoly_fighting.entity.Report3B;
import com.fighting.fpoly_fighting.entity.Report3C;
import com.fighting.fpoly_fighting.entity.Report3D;
import com.fighting.fpoly_fighting.entity.Report3E;
import com.fighting.fpoly_fighting.entity.Report4A;
import com.fighting.fpoly_fighting.entity.Report4B;
import com.fighting.fpoly_fighting.entity.Report4C;
import com.fighting.fpoly_fighting.entity.Report4D;
import com.fighting.fpoly_fighting.entity.Report4E;
import com.fighting.fpoly_fighting.entity.Report5A;
import com.fighting.fpoly_fighting.entity.Report5B;
import com.fighting.fpoly_fighting.entity.Report5C;
import com.fighting.fpoly_fighting.entity.Report5D;
import com.fighting.fpoly_fighting.entity.Report5E;
import com.fighting.fpoly_fighting.service.ReportService;

@Service
public class ReportServiceImpl implements ReportService {

	@Autowired
	ReportDAO reportDao ;
	
	@Override
	public List< Report1A > getReport1A() {
		return reportDao.getReport1A() ;
	}

	@Override
	public List< Report1B > getReport1B() {
		return reportDao.getReport1B() ;
	}
	
	@Override
	public List< Report2A > getReport2A( Date startDate , Date endDate ) {
		return reportDao.getReport2A( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public List< Report2B > getReport2B( Date startDate , Date endDate ) {
		return reportDao.getReport2B( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public List< Report2C > getReport2C( Date startDate , Date endDate ) {
		return reportDao.getReport2C( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public List< Report2D > getReport2D( Date startDate , Date endDate ) {
		return reportDao.getReport2D( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public Report2E getReport2E( Date startDate , Date endDate ) {
		return reportDao.getReport2E( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public List< Report3A > getReport3A( Date startDate , Date endDate , Long categoryId ) {
		return reportDao.getReport3A( startDate != null , endDate != null , startDate , endDate , categoryId != null , categoryId ) ;
	}
	
	@Override
	public List< Report3B > getReport3B( Date startDate , Date endDate , Long categoryId ) {
		return reportDao.getReport3B( startDate != null , endDate != null , startDate , endDate , categoryId != null , categoryId ) ;
	}
	
	@Override
	public List< Report3C > getReport3C( Date startDate , Date endDate , Long categoryId ) {
		return reportDao.getReport3C( startDate != null , endDate != null , startDate , endDate , categoryId != null , categoryId ) ;
	}
	
	@Override
	public List< Report3D > getReport3D( Date startDate , Date endDate , Long categoryId ) {
		return reportDao.getReport3D( startDate != null , endDate != null , startDate , endDate , categoryId != null , categoryId ) ;
	}
	
	@Override
	public List< Report3E > getReport3E( Date startDate , Date endDate , Long categoryId ) {
		return reportDao.getReport3E( startDate != null , endDate != null , startDate , endDate , categoryId != null , categoryId ) ;
	}

	@Override
	public List< Report4A > getReport4A( Date startDate , Date endDate ) {
		return reportDao.getReport4A( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public List< Report4B > getReport4B( Date startDate , Date endDate ) {
		return reportDao.getReport4B( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public List< Report4C > getReport4C( Date startDate , Date endDate ) {
		return reportDao.getReport4C( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public List< Report4D > getReport4D( Date startDate , Date endDate ) {
		return reportDao.getReport4D( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public List< Report4E > getReport4E( Date startDate , Date endDate ) {
		return reportDao.getReport4E( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public List< Report5A > getReport5A( java.time.LocalDate startDate , java.time.LocalDate endDate ) {
		return reportDao.getReport5A( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public List< Report5B > getReport5B( java.time.LocalDate startDate , java.time.LocalDate endDate ) {
		return reportDao.getReport5B( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public List< Report5C > getReport5C( java.time.LocalDate startDate , java.time.LocalDate endDate ) {
		return reportDao.getReport5C( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public List< Report5D > getReport5D( java.time.LocalDate startDate , java.time.LocalDate endDate ) {
		return reportDao.getReport5D( startDate != null , endDate != null , startDate , endDate ) ;
	}
	
	@Override
	public Report5E getReport5E( java.time.LocalDate startDate , java.time.LocalDate endDate ) {
		return reportDao.getReport5E( startDate != null , endDate != null , startDate , endDate ) ;
	}

}
