package com.fighting.fpoly_fighting.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fighting.fpoly_fighting.entity.Cart;
import com.fighting.fpoly_fighting.entity.Category;
import com.fighting.fpoly_fighting.entity.Order;
import com.fighting.fpoly_fighting.entity.OrderInfo;
import com.fighting.fpoly_fighting.entity.User;
import com.fighting.fpoly_fighting.service.CategoryService;
import com.fighting.fpoly_fighting.service.CustomerService;
import com.fighting.fpoly_fighting.service.OrderService;
import com.fighting.fpoly_fighting.service.ProductService;
import com.fighting.fpoly_fighting.service.SessionService;

@Controller
public class OrderController {

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
	
	@PostMapping( "/khach-hang/dat-hang" )
	public String order( 
			Model model ,
			@Valid @ModelAttribute( "orderInfo" ) OrderInfo orderInfo ,
			BindingResult result ,
			RedirectAttributes ra
		) {
		if( result.hasErrors() ) {
			model.addAttribute( "alert" , "Đặt hàng thất bại!" ) ;
			return "/user/cart/checkout" ;
		}
		final User customer = customerService.getLoggedInCustomer() ;
		final Cart cart = sessionService.get( "cart" ) ;
		try {
			orderService.order( customer , cart , orderInfo ) ;
			ra.addFlashAttribute( "alert" , "Đặt hàng thành công.\nVui lòng chờ G2Shop xác nhận đơn hàng.\nBạn có thể kiểm tra đơn hàng mới nhất của bạn tại lịch sử đặt hàng!" ) ;
			cart.clear() ;
			sessionService.set( "cart" , cart ) ;
		} catch( Exception ex ) {
			ra.addFlashAttribute( "alert" , "Đặt hàng thất bại!" ) ;
		}
		return "redirect:/khach-hang/lich-su-dat-hang" ;
	}
	
	@RequestMapping( "/khach-hang/lich-su-dat-hang" )
	String viewOrderHistory( 
			Model model 
		) {
		final User customer = customerService.getLoggedInCustomer() ;
		final Sort sort =  Sort.by( Direction.DESC , "createdDate" ) ;
		List< Order > orderList = orderService.findByCustomerId( customer.getId() , sort ) ;
		model.addAttribute( "orderList" , orderList ) ;
		return "/user/order/list" ;
	}
	
	@RequestMapping( "/khach-hang/lich-su-dat-hang/xem-don-hang" )
	String viewOrderDetails( 
			Model model ,
			@RequestParam( name = "id" ) Long orderId
		) {
		final Order order  = orderService.findById( orderId ) ;
		model.addAttribute( "order" , order ) ;
		return "/user/order/view" ;
	}
	
	@RequestMapping( "/khach-hang/huy-don-hang" )
	String cancelOrder( 
			Model model ,
			@RequestParam( name = "id" ) Long orderId ,
			RedirectAttributes ra
		) {
		final Order order  = orderService.findById( orderId ) ;
		final User customer = customerService.getLoggedInCustomer() ;
		if( orderService.cancel( orderId , customer ) ) {
			model.addAttribute( "alert" , "Hủy đơn hàng thành công!" ) ;
		} else {
			model.addAttribute( "alert" , "Hủy đơn hàng thất bại!" ) ;
		}
		model.addAttribute( "order" , order ) ;
		return "/user/order/view" ;
	}
	
	@ModelAttribute( name = "categories" )
	List< Category > getCategories() {
		return categoryService.findAll();
	}
	
	
	
}
