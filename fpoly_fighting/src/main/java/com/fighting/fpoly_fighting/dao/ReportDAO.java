package com.fighting.fpoly_fighting.dao;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

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

@Repository
public interface ReportDAO extends JpaRepository< Report1A , Long >{

	@Query( value = "SELECT new Report1A( c , count( p ) , COALESCE( sum( p.quantity ) , 0L ) ) "
			+ "FROM Product p RIGHT OUTER JOIN p.category c ON c.id = p.category.id "
			+ "GROUP BY c ORDER BY c.id" )
	List< Report1A > getReport1A() ;
	
	@Query( value = "SELECT new Report1B( b , count( p ) , COALESCE( sum( p.quantity ) , 0L ) ) "
			+ "FROM Product p RIGHT OUTER JOIN p.brand b ON b.id = p.brand.id "
			+ "GROUP BY b ORDER BY b.id" )
	List< Report1B > getReport1B() ;
	
	@Query( value = "SELECT new Report2A( YEAR( o.createdDate ) , count ( Distinct o ) , sum( d.quantity ) , sum( d.price * d.quantity ) , sum( d.price * d.quantity + o.shippingFee ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) "
			+ "GROUP BY YEAR( o.createdDate ) ORDER BY YEAR( o.createdDate ) DESC" )
	List< Report2A > getReport2A( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate ) ;
	
	@Query( value = "SELECT new Report2B( YEAR( o.createdDate ) , MONTH( o.createdDate ) / 4 + 1 , count( Distinct o ) , sum( d.quantity ) , sum( d.price * d.quantity ) , sum( d.price * d.quantity + o.shippingFee ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) "
			+ "GROUP BY YEAR( o.createdDate ) , MONTH( o.createdDate ) / 4 "
			+ "ORDER BY YEAR( o.createdDate ) DESC , MONTH( o.createdDate ) / 4 DESC" )
	List< Report2B > getReport2B( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate ) ;
	
	@Query( value = "SELECT new Report2C( YEAR( o.createdDate ) , MONTH( o.createdDate ) , count( Distinct o ) , sum( d.quantity ) , sum( d.price * d.quantity ) , sum( d.price * d.quantity + o.shippingFee ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) "
			+ "GROUP BY YEAR( o.createdDate ) , MONTH( o.createdDate ) "
			+ "ORDER BY YEAR( o.createdDate ) DESC , MONTH( o.createdDate ) DESC" )
	List< Report2C > getReport2C( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate ) ;
	
	@Query( value = "SELECT new Report2D( YEAR( o.createdDate ) , MONTH( o.createdDate ) , DAY( o.createdDate ) , count( Distinct o ) , sum( d.quantity ) , sum( d.price * d.quantity ) , sum( d.price * d.quantity + o.shippingFee ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) "
			+ "GROUP BY YEAR( o.createdDate ) , MONTH( o.createdDate ) , DAY( o.createdDate ) "
			+ "ORDER BY YEAR( o.createdDate ) DESC , MONTH( o.createdDate ) DESC , DAY( o.createdDate ) DESC" )
	List< Report2D > getReport2D( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate ) ;
	
	@Query( value = "SELECT new Report2E( count( Distinct o ) , sum( d.quantity ) , sum( d.price * d.quantity ) , sum( d.price * d.quantity + o.shippingFee ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) " )
	Report2E getReport2E( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate ) ;
	
	@Query( value = "SELECT new Report3A( YEAR( o.createdDate ) , d.product.id , sum( d.quantity ) , sum( d.price * d.quantity ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) AND ( :isByCategoryId = false OR d.product.category.id = :categoryId ) "
			+ "GROUP BY YEAR( o.createdDate ) , d.product.id "
			+ "ORDER BY YEAR( o.createdDate ) DESC , d.product.id" )
	List< Report3A > getReport3A( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate , Boolean isByCategoryId , Long categoryId ) ;
	
	@Query( value = "SELECT new Report3B( YEAR( o.createdDate ) , MONTH( o.createdDate ) / 4 + 1 , d.product.id , sum( d.quantity ) , sum( d.price * d.quantity ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) AND ( :isByCategoryId = false OR d.product.category.id = :categoryId ) "
			+ "GROUP BY YEAR( o.createdDate ) , MONTH( o.createdDate ) / 4 , d.product.id "
			+ "ORDER BY YEAR( o.createdDate ) DESC , MONTH( o.createdDate ) / 4 DESC , d.product.id" )
	List< Report3B > getReport3B( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate , Boolean isByCategoryId , Long categoryId ) ;
	
	@Query( value = "SELECT new Report3C( YEAR( o.createdDate ) , MONTH( o.createdDate ) , d.product.id , sum( d.quantity ) , sum( d.price * d.quantity ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) AND ( :isByCategoryId = false OR d.product.category.id = :categoryId ) "
			+ "GROUP BY YEAR( o.createdDate ) , MONTH( o.createdDate ) , d.product.id "
			+ "ORDER BY YEAR( o.createdDate ) DESC , MONTH( o.createdDate ) DESC , d.product.id" )
	List< Report3C > getReport3C( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate , Boolean isByCategoryId , Long categoryId ) ;
	
	@Query( value = "SELECT new Report3D( YEAR( o.createdDate ) , MONTH( o.createdDate ) , DAY( o.createdDate ) , d.product.id , sum( d.quantity ) , sum( d.price * d.quantity ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) AND ( :isByCategoryId = false OR d.product.category.id = :categoryId ) "
			+ "GROUP BY YEAR( o.createdDate ) , MONTH( o.createdDate ) , DAY( o.createdDate ) , d.product.id "
			+ "ORDER BY YEAR( o.createdDate ) DESC , MONTH( o.createdDate ) DESC , DAY( o.createdDate ) DESC , d.product.id" )
	List< Report3D > getReport3D( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate , Boolean isByCategoryId , Long categoryId ) ;
	
	@Query( value = "SELECT new Report3E( d.product.id , sum( d.quantity ) , sum( d.price * d.quantity ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) AND ( :isByCategoryId = false OR d.product.category.id = :categoryId ) "
			+ "GROUP BY d.product.id" )
	List< Report3E > getReport3E( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate , Boolean isByCategoryId , Long categoryId ) ;
	
	@Query( value = "SELECT new Report4A( YEAR( o.createdDate ) , d.product.category.id , sum( d.quantity ) , sum( d.price * d.quantity ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) "
			+ "GROUP BY YEAR( o.createdDate ) , d.product.category.id "
			+ "ORDER BY YEAR( o.createdDate ) DESC , d.product.category.id" )
	List< Report4A > getReport4A( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate ) ;
	
	@Query( value = "SELECT new Report4B( YEAR( o.createdDate ) , MONTH( o.createdDate ) / 4 + 1 , d.product.category.id , sum( d.quantity ) , sum( d.price * d.quantity ) ) FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) "
			+ "GROUP BY YEAR( o.createdDate ) , MONTH( o.createdDate ) / 4 , d.product.category.id "
			+ "ORDER BY YEAR( o.createdDate ) DESC , MONTH( o.createdDate ) / 4 DESC , d.product.category.id" )
	List< Report4B > getReport4B( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate ) ;
	
	@Query( value = "SELECT new Report4C( YEAR( o.createdDate ) , MONTH( o.createdDate ) , d.product.category.id , sum( d.quantity ) , sum( d.price * d.quantity ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) "
			+ "GROUP BY YEAR( o.createdDate ) , MONTH( o.createdDate ) , d.product.category.id "
			+ "ORDER BY YEAR( o.createdDate ) DESC , MONTH( o.createdDate ) DESC , d.product.category.id" )
	List< Report4C > getReport4C( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate ) ;
	
	@Query( value = "SELECT new Report4D( YEAR( o.createdDate ) , MONTH( o.createdDate ) , DAY( o.createdDate ) , d.product.category.id , sum( d.quantity ) , sum( d.price * d.quantity ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) "
			+ "GROUP BY YEAR( o.createdDate ) , MONTH( o.createdDate ) , DAY( o.createdDate ) , d.product.category.id "
			+ "ORDER BY YEAR( o.createdDate ) DESC , MONTH( o.createdDate ) DESC , DAY( o.createdDate ) DESC , d.product.category.id" )
	List< Report4D > getReport4D( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate ) ;
	
	@Query( value = "SELECT new Report4E( d.product.category.id , sum( d.quantity ) , sum( d.price * d.quantity ) ) "
			+ "FROM Order o , OrderDetail d "
			+ "WHERE o.id = d.order.id AND o.orderStatus.id > 0 AND ( :isByStartDate = false OR o.createdDate >= :startDate ) AND ( :isByEndDate = false OR o.createdDate <= :endDate ) "
			+ "GROUP BY d.product.category.id" )
	List< Report4E > getReport4E( Boolean isByStartDate , Boolean isByEndDate , Date startDate , Date endDate ) ;
	
	@Query( value = "SELECT new Report5A( YEAR( v.date ) , sum ( v.visitCount ) ) "
			+ "FROM WebsiteVisit v "
			+ "WHERE ( :isByStartDate = false OR v.date >= :startDate ) AND ( :isByEndDate = false OR v.date <= :endDate ) "
			+ "GROUP BY YEAR( v.date ) ORDER BY YEAR( v.date ) DESC" )
	List< Report5A > getReport5A( Boolean isByStartDate , Boolean isByEndDate , java.time.LocalDate startDate , java.time.LocalDate endDate ) ;
	
	@Query( value = "SELECT new Report5B( YEAR( v.date ) , MONTH( v.date ) / 4 + 1 , sum( v.visitCount ) ) "
			+ "FROM WebsiteVisit v "
			+ "WHERE ( :isByStartDate = false OR v.date >= :startDate ) AND ( :isByEndDate = false OR v.date <= :endDate ) "
			+ "GROUP BY YEAR( v.date ) , MONTH( v.date ) / 4 "
			+ "ORDER BY YEAR( v.date ) DESC , MONTH( v.date ) / 4 DESC" )
	List< Report5B > getReport5B( Boolean isByStartDate , Boolean isByEndDate , java.time.LocalDate startDate , java.time.LocalDate endDate ) ;
	
	@Query( value = "SELECT new Report5C( YEAR( v.date ) , MONTH( v.date ) , sum( v.visitCount ) ) "
			+ "FROM WebsiteVisit v "
			+ "WHERE ( :isByStartDate = false OR v.date >= :startDate ) AND ( :isByEndDate = false OR v.date <= :endDate ) "
			+ "GROUP BY YEAR( v.date ) , MONTH( v.date ) "
			+ "ORDER BY YEAR( v.date ) DESC , MONTH( v.date ) DESC" )
	List< Report5C > getReport5C( Boolean isByStartDate , Boolean isByEndDate , java.time.LocalDate startDate , java.time.LocalDate endDate ) ;
	
	@Query( value = "SELECT new Report5D( YEAR( v.date ) , MONTH( v.date ) , DAY( v.date ) , sum( v.visitCount ) ) "
			+ "FROM WebsiteVisit v "
			+ "WHERE ( :isByStartDate = false OR v.date >= :startDate ) AND ( :isByEndDate = false OR v.date <= :endDate ) "
			+ "GROUP BY YEAR( v.date ) , MONTH( v.date ) , DAY( v.date ) "
			+ "ORDER BY YEAR( v.date ) DESC , MONTH( v.date ) DESC , DAY( v.date ) DESC" )
	List< Report5D > getReport5D( Boolean isByStartDate , Boolean isByEndDate , java.time.LocalDate startDate , java.time.LocalDate endDate ) ;
	
	@Query( value = "SELECT new Report5E( sum( v.visitCount ) ) "
			+ "FROM WebsiteVisit v "
			+ "WHERE ( :isByStartDate = false OR v.date >= :startDate ) AND ( :isByEndDate = false OR v.date <= :endDate )" )
	Report5E getReport5E( Boolean isByStartDate , Boolean isByEndDate , java.time.LocalDate startDate , java.time.LocalDate endDate ) ;
	
}
