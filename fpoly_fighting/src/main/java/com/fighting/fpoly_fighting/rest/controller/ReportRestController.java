package com.fighting.fpoly_fighting.rest.controller;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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

@CrossOrigin( "*" )
@RestController
@RequestMapping( "/rest/reports" )
public class ReportRestController {

	@Autowired
	ReportService reportService ;
	
	@GetMapping( "1A" )
	public List< Report1A > getReport1A() {
		return reportService.getReport1A() ;
	}
	
	@GetMapping( "1B" )
	public List< Report1B > getReport1B() {
		return reportService.getReport1B() ;
	}
	
	@GetMapping( "2A" )
	public List< Report2A > getReport2A(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		return reportService.getReport2A( startDate , endDate ) ;
	}
	
	@GetMapping( "2B" )
	public List< Report2B > getReport2B(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		return reportService.getReport2B( startDate , endDate ) ;
	}
	
	@GetMapping( "2C" )
	public List< Report2C > getReport2C(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		return reportService.getReport2C( startDate , endDate ) ;
	}
	
	@GetMapping( "2D" )
	public List< Report2D > getReport2D(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		return reportService.getReport2D( startDate , endDate ) ;
	}
	
	@GetMapping( "2E" )
	public Report2E getReport2E(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		return reportService.getReport2E( startDate , endDate ) ;
	}
	
	@GetMapping( "3A" )
	public List< Report3A > getReport3A(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate ,
			@RequestParam( name = "categoryId" ) Optional< Long > _categoryId
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		final Long categoryId = _categoryId.isPresent() ? _categoryId.get() : null ;
		return reportService.getReport3A( startDate , endDate , categoryId ) ;
	}
	
	@GetMapping( "3B" )
	public List< Report3B > getReport3B(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate	,
			@RequestParam( name = "categoryId" ) Optional< Long > _categoryId
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		final Long categoryId = _categoryId.isPresent() ? _categoryId.get() : null ;
		return reportService.getReport3B( startDate , endDate , categoryId ) ;
	}
	
	@GetMapping( "3C" )
	public List< Report3C > getReport3C(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate , 
			@RequestParam( name = "categoryId" ) Optional< Long > _categoryId
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		final Long categoryId = _categoryId.isPresent() ? _categoryId.get() : null ;
		return reportService.getReport3C( startDate , endDate , categoryId ) ;
	}
	
	@GetMapping( "3D" )
	public List< Report3D > getReport3D(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate ,
			@RequestParam( name = "categoryId" ) Optional< Long > _categoryId
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		final Long categoryId = _categoryId.isPresent() ? _categoryId.get() : null ;
		return reportService.getReport3D( startDate , endDate , categoryId ) ;
	}
	
	@GetMapping( "3E" )
	public List< Report3E > getReport3E(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate ,
			@RequestParam( name = "categoryId" ) Optional< Long > _categoryId
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		final Long categoryId = _categoryId.isPresent() ? _categoryId.get() : null ;
		return reportService.getReport3E( startDate , endDate , categoryId ) ;
	}
	
	@GetMapping( "4A" )
	public List< Report4A > getReport4A(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		return reportService.getReport4A( startDate , endDate ) ;
	}
	
	@GetMapping( "4B" )
	public List< Report4B > getReport4B(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		return reportService.getReport4B( startDate , endDate ) ;
	}
	
	@GetMapping( "4C" )
	public List< Report4C > getReport4C(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		return reportService.getReport4C( startDate , endDate ) ;
	}
	
	@GetMapping( "4D" )
	public List< Report4D > getReport4D(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		return reportService.getReport4D( startDate , endDate ) ;
	}
	
	@GetMapping( "4E" )
	public List< Report4E > getReport4E(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		return reportService.getReport4E( startDate , endDate ) ;
	}
	
	@SuppressWarnings("deprecation")
	@GetMapping( "5A" )
	public List< Report5A > getReport5A(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		final java.time.LocalDate localStartDate = _startDate.isPresent() ? java.time.LocalDate.of( startDate.getYear() + 1900  , startDate.getMonth() + 1 , startDate.getDate() ) : null ;
		final java.time.LocalDate localEndDate = _startDate.isPresent() ? java.time.LocalDate.of( endDate.getYear() + 1900 , endDate.getMonth() + 1 , endDate.getDate() ) : null ;
		return reportService.getReport5A( localStartDate , localEndDate ) ;
	}
	
	@SuppressWarnings("deprecation")
	@GetMapping( "5B" )
	public List< Report5B > getReport5B(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		final java.time.LocalDate localStartDate = _startDate.isPresent() ? java.time.LocalDate.of( startDate.getYear() + 1900  , startDate.getMonth() + 1 , startDate.getDate() ) : null ;
		final java.time.LocalDate localEndDate = _startDate.isPresent() ? java.time.LocalDate.of( endDate.getYear() + 1900  , endDate.getMonth() + 1 , endDate.getDate() ) : null ;
		return reportService.getReport5B( localStartDate , localEndDate ) ;
	}
	
	@SuppressWarnings("deprecation")
	@GetMapping( "5C" )
	public List< Report5C > getReport5C(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		final java.time.LocalDate localStartDate = _startDate.isPresent() ? java.time.LocalDate.of( startDate.getYear() + 1900  , startDate.getMonth() + 1 , startDate.getDate() ) : null ;
		final java.time.LocalDate localEndDate = _startDate.isPresent() ? java.time.LocalDate.of( endDate.getYear() + 1900  , endDate.getMonth() + 1 , endDate.getDate() ) : null ;
		return reportService.getReport5C( localStartDate , localEndDate ) ;
	}
	
	@SuppressWarnings("deprecation")
	@GetMapping( "5D" )
	public List< Report5D > getReport5D(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		final java.time.LocalDate localStartDate = _startDate.isPresent() ? java.time.LocalDate.of( startDate.getYear() + 1900  , startDate.getMonth() + 1 , startDate.getDate() ) : null ;
		final java.time.LocalDate localEndDate = _startDate.isPresent() ? java.time.LocalDate.of( endDate.getYear() + 1900  , endDate.getMonth() + 1 , endDate.getDate() ) : null ;
		return reportService.getReport5D( localStartDate , localEndDate ) ;
	}
	
	@SuppressWarnings("deprecation")
	@GetMapping( "5E" )
	public Report5E getReport5E(
			@RequestParam( name = "startDate" ) Optional< Long > _startDate ,
			@RequestParam( name = "endDate" ) Optional< Long > _endDate
		) {
		final Date startDate = _startDate.isPresent() ? new Date( _startDate.get() ) : null ;
		final Date endDate = _endDate.isPresent() ? new Date( _endDate.get() ) : null ;
		final java.time.LocalDate localStartDate = _startDate.isPresent() ? java.time.LocalDate.of( startDate.getYear() + 1900  , startDate.getMonth() + 1 , startDate.getDate() ) : null ;
		final java.time.LocalDate localEndDate = _startDate.isPresent() ? java.time.LocalDate.of( endDate.getYear() + 1900  , endDate.getMonth() + 1 , endDate.getDate() ) : null ;
		return reportService.getReport5E( localStartDate , localEndDate ) ;
	}
	
}
