package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;
import java.time.LocalDate;

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
@Table( name = "website_visits" )
@Data
@AllArgsConstructor
@NoArgsConstructor
public class WebsiteVisit implements Serializable {

	private static final long serialVersionUID = -6084934683539349401L ;

	@Id
	@Column( name = "id" )
	@GeneratedValue( strategy = GenerationType.IDENTITY )
	Long id ;
	
	@Column( name = "date" )
	LocalDate date ;
	
	@Column( name = "visitcount" )
	Integer visitCount ;
	
}