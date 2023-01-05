package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;

import javax.validation.constraints.NotBlank;

import org.hibernate.validator.constraints.Length;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderInfo implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Length( min = 3 , max = 50 , message = "Họ và tên người nhận hàng phải từ 3 đến 50 ký tự!" )
	@NotBlank( message = "Họ và tên người nhận hàng không được để trống!" )
	String receiverFullname ;
	
	@Length( min = 5 , max = 255 , message = "Địa chỉ nhận hàng phải từ 5 đến 255 ký tự!" )
	@NotBlank( message = "Họ và tên người nhận hàng không được để trống!" )
	String receiverAddress ;
	
	@Length( min = 9 , max = 11 , message = "Số điện thoại nhận hàng phải từ 9 đến 11 ký tự!" )
	@NotBlank( message = "Số điện thoại không được để trống!" )
	String receiverPhone ;
	
	@Length( max = 255 , message = "Ghi chú có tối đa 255 ký tự!" )
	String note ;

}
