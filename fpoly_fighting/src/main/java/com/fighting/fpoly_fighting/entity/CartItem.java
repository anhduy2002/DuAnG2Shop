package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartItem implements Serializable {

	private static final long serialVersionUID = 1L ;
	
	Integer quantity ;
	Product product ;
	
}
