package com.fighting.fpoly_fighting.service;

import java.util.Date;
import java.util.List;

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

public interface ReportService {
	
	List< Report1A > getReport1A() ;
	
	List< Report1B > getReport1B() ;

	List< Report2A > getReport2A( Date startDate, Date endDate ) ;

	List< Report2B > getReport2B( Date startDate, Date endDate ) ;

	List< Report2C > getReport2C( Date startDate, Date endDate ) ;

	List< Report2D > getReport2D( Date startDate, Date endDate ) ;
	
	Report2E getReport2E( Date startDate, Date endDate ) ;

	List< Report3A > getReport3A( Date startDate, Date endDate , Long categoryId ) ;

	List< Report3B > getReport3B( Date startDate, Date endDate , Long categoryId ) ;
	
	List< Report3C > getReport3C( Date startDate, Date endDate , Long categoryId ) ;
	
	List< Report3D > getReport3D( Date startDate, Date endDate , Long categoryId ) ;
	
	List< Report3E > getReport3E( Date startDate, Date endDate , Long categoryId ) ;

	List< Report4A > getReport4A( Date startDate, Date endDate ) ;

	List< Report4B > getReport4B( Date startDate, Date endDate ) ;
	
	List< Report4C > getReport4C( Date startDate, Date endDate ) ;
	
	List< Report4D > getReport4D( Date startDate, Date endDate ) ;
	
	List< Report4E > getReport4E( Date startDate, Date endDate ) ;
	
	List< Report5A > getReport5A( java.time.LocalDate startDate, java.time.LocalDate endDate ) ;

	List< Report5B > getReport5B( java.time.LocalDate startDate, java.time.LocalDate endDate ) ;
	
	List< Report5C > getReport5C( java.time.LocalDate startDate, java.time.LocalDate endDate ) ;
	
	List< Report5D > getReport5D( java.time.LocalDate startDate, java.time.LocalDate endDate ) ;
	
	Report5E getReport5E( java.time.LocalDate startDate, java.time.LocalDate endDate ) ;


}
