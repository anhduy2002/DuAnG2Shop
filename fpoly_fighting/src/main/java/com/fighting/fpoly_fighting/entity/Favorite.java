package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;
import java.util.Date;

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
@NoArgsConstructor
@AllArgsConstructor
@Data
@Table( name = "favorites" )
public class Favorite implements Serializable {
	
	private static final long serialVersionUID = 1L ;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	Long id ;
	
	@Column( name = "iscanceled" )
	Boolean isCanceled ;
	
	@Column( name = "createddate" )
	Date createdDate ;
	
	@ManyToOne
	@JsonIgnoreProperties( value = { "applications" , "hibernateLazyInitializer" } )
	@JoinColumn(name = "customerid", referencedColumnName = "id")
	User customer ;
	
	@ManyToOne
	@JsonIgnoreProperties( value = { "applications" , "hibernateLazyInitializer" } )
	@JoinColumn( name = "productid" , referencedColumnName = "id" )
	Product product ;
	
}
