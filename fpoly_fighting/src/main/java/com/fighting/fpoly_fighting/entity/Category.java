package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table( name = "categories" )
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Category implements Serializable {

	private static final long serialVersionUID = 364062987691158104L ;

	@Id
	@GeneratedValue( strategy = GenerationType.IDENTITY )
	Long id ;
	
	@Column( name = "name" )
	String name ;
	
	@Column( name = "slug" )
	String slug ;
	
	@Column( name = "imagename" )
	String imageName ;
	
	@Column( name = "isdeleted" )
	Boolean isDeleted ;
	
}
