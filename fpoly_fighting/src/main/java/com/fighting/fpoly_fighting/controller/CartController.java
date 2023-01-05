package com.fighting.fpoly_fighting.controller;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fighting.fpoly_fighting.entity.Cart;
import com.fighting.fpoly_fighting.entity.Category;
import com.fighting.fpoly_fighting.entity.OrderInfo;
import com.fighting.fpoly_fighting.entity.Product;
import com.fighting.fpoly_fighting.entity.User;
import com.fighting.fpoly_fighting.service.CategoryService;
import com.fighting.fpoly_fighting.service.CustomerService;
import com.fighting.fpoly_fighting.service.OrderService;
import com.fighting.fpoly_fighting.service.ProductService;
import com.fighting.fpoly_fighting.service.SessionService;

@Controller
public class CartController {

	@Autowired
	SessionService sessionService ;

	@Autowired
	ProductService productService ;
	
	@Autowired
	CustomerService customerService ;
	
	@Autowired
	OrderService orderService ;

	@Autowired
	CategoryService categoryService ;
	
	@Autowired
	HttpServletRequest req ;
	
	@GetMapping( "/gio-hang" )
	public String view(
		) {
		return "/user/cart/view";
	}
	
	@RequestMapping( "/gio-hang/them-san-pham" )
	String add( 
			@RequestParam( "productId" ) Long productId ,
			@RequestParam( "quantity" ) Optional< Integer > _quantity ,
			HttpServletRequest request ,
			RedirectAttributes ra
		) {
		final Cart cart = sessionService.get( "cart" ) ;
		final Product product = productService.findById( productId ) ;
		if( _quantity.isPresent() ) {
			cart.addProducts( product , _quantity.get() ) ;
		} else {
			cart.addProducts( product ) ;
		}
		String referer = request.getHeader("Referer");
		ra.addFlashAttribute( "referer" , referer ) ;
		return "redirect:/gio-hang" ;
	}
	
	@PostMapping( "/gio-hang/cap-nhat" )
	String update( 
			@RequestParam( "id" ) int id ,
			@RequestParam( "quantity" ) int quantity ,
			RedirectAttributes ra
		) {
		final Cart cart = sessionService.get( "cart" ) ;
		cart.update( id , quantity ) ;
		return "redirect:/gio-hang" ;
	}

	@RequestMapping( "/gio-hang/xoa-san-pham" )
	String remove( @RequestParam( "id" ) int id ) {
		final Cart cart = sessionService.get( "cart" ) ;
		cart.removeItem( id ) ;
		return "redirect:/gio-hang" ;
	}
	
	@RequestMapping( "/gio-hang/lam-moi" )
	String clear() {
		final Cart cart = sessionService.get( "cart" ) ;
		cart.clear() ;
		return "redirect:/gio-hang" ;
	}
	
	@RequestMapping( "/gio-hang/xem-truoc-don-hang" )
	public String checkout( 
			Model model ,
			RedirectAttributes ra ) {
		final Cart cart = sessionService.get( "cart" ) ;
		if( cart.isEmpty() ) {
			ra.addFlashAttribute( "alert" , "Giỏ hàng trống.\nVui lòng thêm sản phẩm vào giỏ hàng!" ) ;
			return "redirect:/gio-hang" ;
		}
		final User customer = customerService.getLoggedInCustomer() ;
		if( customer == null ) {
			ra.addFlashAttribute( "alert" , "Vui lòng đăng nhập để đặt hàng!" ) ;
			return "redirect:/dang-nhap" ;
		}
		final OrderInfo orderInfo = new OrderInfo() ;
		orderInfo.setReceiverFullname( customer.getFullname() ) ;
		orderInfo.setReceiverAddress( customer.getAddress() ) ;
		orderInfo.setReceiverPhone( customer.getPhone() ) ;
		model.addAttribute( "createdDate" , new Date() ) ;
		model.addAttribute( "orderInfo" , orderInfo ) ;
		return "user/cart/checkout" ;
	}
	
	@ModelAttribute(name = "categories")
	List< Category > getCategories() {
		return categoryService.findAll();
	}
	
}
