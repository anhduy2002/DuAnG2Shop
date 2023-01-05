package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "roles")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Role implements Serializable {

	private static final long serialVersionUID = 1L ;

	@Id
	@Column( name = "id" )
	@GeneratedValue( strategy =  GenerationType.IDENTITY )
	Long id ;
	
	@Column( name = "name" )
	@Size( min = 1 , max = 20 , message = "Tên vai trò phải từ 1 đến 20 ký tự!" )
	@NotBlank( message = "Tên vai trò không được để trống!" )
	String name ;
	
}
