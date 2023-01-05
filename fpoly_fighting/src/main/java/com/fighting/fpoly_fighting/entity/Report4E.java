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
public class Report4E implements Serializable {

	private static final long serialVersionUID = 1L ;
	
	@Id
	Long categoryId ;
	
	Long count ;
	Double totalCost ;
	
}
