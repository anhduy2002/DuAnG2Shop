package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Report2A implements Serializable {

	private static final long serialVersionUID = 1L ;

	@Id
	Integer year ;
	
	Long count ;
	Long productCount ;
	Double totalProductCost ;
	Double totalCost ;
}
