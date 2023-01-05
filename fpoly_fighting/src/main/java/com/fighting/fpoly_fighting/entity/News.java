package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;
import java.util.Date;

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
@Table( name = "news" )
@Data
@AllArgsConstructor
@NoArgsConstructor
public class News implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue( strategy = GenerationType.IDENTITY )
	Long id ;
	
	@Column( name = "createddate" )
	Date createdDate ;
	
	@Column( name = "title" )
	String title ;
	
	@Column( name = "imagename" )
	String imageName ;
	
	@Column( name = "content" )
	String content ;
	
	@Column( name = "isshowedonhomepage" )
	Boolean isShowedOnHomepage ;

	@Column( name = "isdeleted" )
	Boolean isDeleted ;
	
}
