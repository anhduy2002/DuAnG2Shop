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

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "order_details")
@NoArgsConstructor
@AllArgsConstructor
@Data
public class OrderDetail implements Serializable {
	
	private static final long serialVersionUID = 1L ;

	@Id
	@GeneratedValue( strategy = GenerationType.IDENTITY )
	Long id ;
	
	@Column( name = "price" )
	Double price ;
	
	@Column( name = "quantity" )
	Integer quantity ;
	
	@ManyToOne
	@JoinColumn( name = "orderid" , referencedColumnName = "id" )
	@JsonIgnoreProperties( value = { "applications" , "hibernateLazyInitializer" } )
	Order order ;
	
	@ManyToOne
	@JoinColumn( name = "productid" , referencedColumnName = "id" )
	@JsonIgnoreProperties( value = { "applications" , "hibernateLazyInitializer" } )
	Product product ;
	
}
