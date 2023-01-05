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
public class Report3C implements Serializable {

	private static final long serialVersionUID = 1L ;
	
	Integer year ;
	
	@Id
	Integer month ;
	
	Long productId ;
	Long count ;
	Double totalCost ;
	
}
