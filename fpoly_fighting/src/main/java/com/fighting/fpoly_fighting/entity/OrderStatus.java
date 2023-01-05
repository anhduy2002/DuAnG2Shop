package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table( name = "order_statuses" )
@NoArgsConstructor
@AllArgsConstructor
@Data
public class OrderStatus implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	Integer id ;
	
	@Column( name = "name" )
	String name ;
	
}
