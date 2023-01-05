package com.fighting.fpoly_fighting.entity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Cart implements Serializable {

	private static final long serialVersionUID = 1L;
	
	List< CartItem > items = new ArrayList< CartItem >() ;
	
	public void addProducts( Product product ) {
		for( final CartItem _item : this.getItems() ) {
			if( _item.getProduct().getId().equals( product.getId() ) ) {
				_item.setQuantity( Math.min( _item.getQuantity() + 1 , 99 ) ) ;
				return ;
			}
		}
		final CartItem newItem = new CartItem() ;
		newItem.setProduct( product ) ;
		newItem.setQuantity( 1 ) ;
		this.getItems().add( newItem ) ;
	}
	
	public void addProducts( Product product , int quantity ) {
		for( final CartItem _item : this.getItems() ) {
			if( _item.getProduct().getId().equals( product.getId() ) ) {
				_item.setQuantity( Math.min( _item.getQuantity() + quantity , 99 ) ) ;
				return ;
			}
		}
		final CartItem newItem = new CartItem() ;
		newItem.setProduct( product ) ;
		newItem.setQuantity( Math.min( quantity , 99 ) ) ;
		this.getItems().add( newItem ) ;
	}
	
	public void update( int id , int quantity ) {
		final CartItem item = this.getItems().get( id ) ;
		item.setQuantity( quantity < 1 ? 1 : Math.min( quantity , 99 ) )  ;
	}
	
	public Integer getTotalItems() {
		Integer sum = 0 ;
		for( final CartItem item : this.getItems() ) {
			sum += item.getQuantity() ;
		}
		return sum ;
	}
	
	public Double getTotalCost() {
		Double sum = 0. ;
		for( CartItem item : this.getItems() ) {
			sum += item.getQuantity() * item.getProduct().getSalePrice() ;
		}
		return sum ;
	}
	
	public void removeItem( int id ) {
		this.getItems().remove( id ) ;
	}
	
	public void clear() {
		this.getItems().clear() ;
	}
	
	public boolean isEmpty() {
		return this.getItems().isEmpty() ;
	}
	
}
