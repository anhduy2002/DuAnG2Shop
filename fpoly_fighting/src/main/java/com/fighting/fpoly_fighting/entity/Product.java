package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.validation.constraints.Size;

import org.hibernate.annotations.Formula;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table( name = "products" )
@NoArgsConstructor
@AllArgsConstructor
@Data
public class Product implements Serializable {
	
	private static final long serialVersionUID = 1L ;

	@Id
	@GeneratedValue( strategy = GenerationType.IDENTITY )
	Long id ;
	
	@Column( name = "name" )
	@Size( max = 255 , message ="Name must be less than 255 characters" )
	String name;
	
	@Column( name = "quantity" )
	Integer quantity;
	
	@Column( name = "discount" )
	Integer discount;
	
	@Column( name = "price" )
	Double price;
	
	@Column( name = "imagename" )
	String imageName ;
	
	@Column( name = "image1name" )
	String image1Name ;
	
	@Column( name = "image2name" )
	String image2Name ;
	
	@Column( name = "image3name" )
	String image3Name ;
	
	@Column( name = "image4name" )
	String image4Name ;
	
	@Column( name = "image5name" )
	String image5Name ;
	
	@Column( name = "description" )
	String description ;
	
	@Column( name = "viewcount" )
	Integer viewCount ;
	
	@Column( name = "slug" )
	@Size( max = 255, message = "Slug must be less than 255 characters" )
	String slug ;
	
	@Column( name = "isdeleted" )
	Boolean isDeleted ;
	
	@Formula( "price / 100 * ( 100 - discount )" )
	Double salePrice ;

	@Formula( "( SELECT count( * ) FROM favorites o WHERE o.productId = id AND o.isCanceled = 0 )" )
	Long likesCount ;
	
	@Formula("( SELECT IIF( SUM( d.quantity ) IS NULL , 0 , SUM( d.quantity ) ) FROM orders o , order_details d WHERE d.productId = id AND o.id = d.orderId AND o.orderStatusId > 0 )" )
	Long saleCount ;
	
	@ManyToOne
	@JsonIgnoreProperties( value = { "applications", "hibernateLazyInitializer" } )
	@JoinColumn( name = "categoryid", referencedColumnName = "id" )
	Category category ;
	
	@ManyToOne
	@JsonIgnoreProperties( value = { "applications" , "hibernateLazyInitializer" } )
	@JoinColumn( name = "brandid" , referencedColumnName = "id" )
	Brand brand ;
	
}
