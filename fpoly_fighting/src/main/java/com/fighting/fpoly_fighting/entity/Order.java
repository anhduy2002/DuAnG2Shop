package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.Formula;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Data
@Table( name = "orders" )
public class Order implements Serializable {

	private static final long serialVersionUID = 1L ;

	@Id
	@GeneratedValue( strategy = GenerationType.IDENTITY )
	Long id ;
	
	@Column( name = "receiverfullname" )
	String receiverFullname ;
	
	@Column( name = "receiveraddress" )
	String receiverAddress ;
	
	@Column( name = "receiverphone" )
	String receiverPhone ;
	
	@Column( name = "createddate" )
	Date createdDate ;
	
	@Column( name = "receiveddate" )
	Date receivedDate ;
	
	@Column( name = "shippingfee" )
	Double shippingFee ;
	
	@Column( name = "note" )
	String note ;
	
	@Formula( "( SELECT SUM( CAST( d.price AS Float ) * d.quantity ) FROM Order_details d WHERE d.orderId = id ) + shippingFee" )
	Double totalCost ;
	
	@Formula( "( SELECT SUM( CAST( d.price AS Float ) * d.quantity ) FROM Order_details d WHERE d.orderId = id )" )
	Double totalProductCost ;
	
	@ManyToOne
	@JsonIgnoreProperties( value = { "applications" , "hibernateLazyInitializer" } )
	@JoinColumn( name = "customerid" , referencedColumnName = "id" )
	User customer ;
	
	@ManyToOne
	@JsonIgnoreProperties( value = { "applications" , "hibernateLazyInitializer" } )
	@JoinColumn(name = "confirmingstaffid", referencedColumnName = "id" )
	User confirmingStaff ;
	
	@ManyToOne
	@JsonIgnoreProperties( value = { "applications" , "hibernateLazyInitializer" } )
	@JoinColumn(name = "shippingstaffid", referencedColumnName = "id" )
	User shippingStaff ;
	
	@ManyToOne
	@JsonIgnoreProperties( value = { "applications" , "hibernateLazyInitializer" } )
	@JoinColumn( name = "orderstatusid", referencedColumnName = "id" )
	OrderStatus orderStatus ;
	
	@JsonIgnore
	@OneToMany( mappedBy = "order" )
	List< OrderDetail > details ;
	
}
