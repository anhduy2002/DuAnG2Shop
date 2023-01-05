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
import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table( name = "users" )
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User implements Serializable{
	
	private static final long serialVersionUID = 1L ;

	@Id
	@Column( name = "id" )
	@GeneratedValue( strategy = GenerationType.IDENTITY )
	Long id;
	
	@Column( name = "username" )
	@Size( min = 3 , max = 50 , message = "Tên đăng nhập phải từ 3 đến 50 ký tự!" )
	@NotBlank( message = "Tên đăng nhập không được để trống!" )
	String username;
	
	@Column( name = "fullname" )
	@Size( min = 3 , max = 50, message ="Họ và tên phải từ 3 đến 50 ký tự!" )
	@NotBlank( message = "Họ và tên không được để trống!" )
	String fullname;
	
	@Column( name = "hashpassword" )
	@Size( min = 3 , message ="Mật khẩu phải có ít nhất 3 ký tự!" )
	@NotBlank( message = "Mật khẩu không được để trống!" )
	String hashPassword ;
	
	@Column( name = "email" )
	@Email( message = "Email không hợp lệ!" )
	@Size( max = 50 , message ="Email có tối đa 50 ký tự!" )
	@NotBlank( message = "Email không được để trống!" )
	String email;
	
	@Column( name = "phone")
	@Length( min = 9 , max = 12 , message = "Số điện thoại phải từ 9 đến 12 ký tự!" )
	@NotBlank( message = "Số điện thoại không được để trống!" )
	String phone;
	
	@Column( name = "address" )
	@Length( min = 5 , max = 255 , message = "Địa chỉ phải từ 5 đến 250 ký tự!" )
	@NotBlank( message = "Địa chỉ không được để trống!" )
	String address;
	
	@Column( name = "createddate" )
	Date createdDate ;
	
	@Column( name = "resetpasswordcode" )
	String resetPasswordCode ;
	
	@Column( name = "isenabled" )
	Boolean isEnabled ;
	
	@Column( name = "isdeleted" )
	Boolean isDeleted ;

	@ManyToOne
	@JoinColumn( name = "roleid" , referencedColumnName = "id" )
	@JsonIgnoreProperties( value = { "application" , "hibernateLazyInitializer" } )
	Role role ;
	
}