package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.Length;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table( name = "basic_information" )
@Data
@AllArgsConstructor
@NoArgsConstructor
public class BasicInformation implements Serializable{

	private static final long serialVersionUID = -2708049147167563730L;

	@Id
	@Column( name = "id" )
	@GeneratedValue(strategy = GenerationType.IDENTITY )
	Long id ;
	
	@Column( name = "title" )
	@Length( min = 5 , max = 255 , message = "Giới thiệu tiêu đề trang website phải từ 5 đến 50 ký tự!" )
	@NotBlank( message = "Giới thiệu tiêu đề trang website không được để trống!" )
	String title ;
	
	@Column( name = "phone")
	@Length( min = 9 , max = 12 , message = "Số điện thoại phải từ 9 đến 12 ký tự!" )
	@NotBlank( message = "Số điện thoại không được để trống!" )
	String phone ;
	
	@Column( name = "phone2")
	@Length( min = 9 , max = 12 , message = "Số điện thoại thứ 2 phải từ 9 đến 12 ký tự!" )
	String phone2 ;
	
	@Column( name = "email" )
	@Email( message = "Email không hợp lệ!" )
	@Size( max = 50 , message ="Email có tối đa 50 ký tự!" )
	@NotBlank( message = "Email không được để trống!" )
	String email ;
	
	@Column( name = "address" )
	@Length( min = 5 , max = 255 , message = "Địa chỉ phải từ 5 đến 255 ký tự!" )
	@NotBlank( message = "Địa chỉ không được để trống!" )
	String address ;
	
	@Column( name = "embedaddresscode" )
	@NotBlank( message = "Mã nhúng địa chỉ không được để trống!" )
	String embedAddressCode ;
	
	@Column( name = "embedhelpyoutubevideoids" )
	String embedHelpYoutubeVideoIds ;
	
	@Column( name = "termsandpolicies" )
	String termsAndPolicies ;
	
	public String getHelpPageCode() {
		String code = "" ;
		final String[] idList = embedHelpYoutubeVideoIds.split( ";" ) ;
		for( int i = 0 ; i < idList.length ; i ++ ) {
			final String id = idList[ i ].trim() ;
			code += "<div class='mt-4 mb-5'>"
				+ "<iframe class='d-none d-lg-block w-100 v-shadow-5' height='600' src='https://www.youtube.com/embed/" + id + "' title='YouTube video player' frameborder='0' allow='accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe>"
				+ "<iframe class='d-lg-none w-100 v-shadow-5' height='250' src='https://www.youtube.com/embed/" + id + "' title='YouTube video player' frameborder='0' allow='accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe>"
				+ "</div>" ;
		}
		return code ;
	}
	
}