package com.fighting.fpoly_fighting.controller;

import java.util.Arrays;
import java.util.List;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;

import com.fighting.fpoly_fighting.entity.Brand;
import com.fighting.fpoly_fighting.entity.Category;
import com.fighting.fpoly_fighting.entity.News;
import com.fighting.fpoly_fighting.entity.Product;
import com.fighting.fpoly_fighting.entity.User;
import com.fighting.fpoly_fighting.service.BrandService;
import com.fighting.fpoly_fighting.service.CategoryService;
import com.fighting.fpoly_fighting.service.CustomerService;
import com.fighting.fpoly_fighting.service.FavoriteService;
import com.fighting.fpoly_fighting.service.NewsService;
import com.fighting.fpoly_fighting.service.ProductService;
import com.fighting.fpoly_fighting.service.SessionService;

@Controller
public class HomeController {

	@Autowired
	HttpServletRequest req ;
	
	@Autowired
	NewsService newsService ;
	
	@Autowired
	CategoryService categoryService ;
	
	@Autowired
	BrandService brandService ;
	
	@Autowired
	ProductService productService ;
	
	@Autowired
	CustomerService customerService ;
	
	@Autowired
	FavoriteService favoriteService ;
	
	@Autowired
	SessionService sessionService ;
	
	@GetMapping( "/" )
	public String viewHomePage( Model model ) {
		
		//slide
		final List< News > newsList = newsService.findByIsShowedOnHomepageTrueAndIsDeletedFalse() ;
		model.addAttribute( "newsList" , newsList ) ;
		
		Sort sort ;
		Pageable pageable , pageable2 ;
		List< List< Product > > list ;
		
		//bestDiscountProductList
		sort = Sort.by( Direction.DESC , "discount" ) ;
		pageable = PageRequest.of( 0 , 4 , sort ) ;
		pageable2 = PageRequest.of( 1 , 4 , sort ) ;
		list = Arrays.asList( productService.findAll( pageable ) , productService.findAll( pageable2 ) ) ;
		model.addAttribute( "bestDiscountProductList" , list ) ;
		
		//bestFavoriteProductList
		sort = Sort.by( Direction.DESC , "likesCount" ) ;
		pageable = PageRequest.of( 0 , 4 , sort ) ;
		pageable2 = PageRequest.of( 1 , 4 , sort ) ;
		list = Arrays.asList( productService.findAll( pageable ) , productService.findAll( pageable2 ) ) ;
		model.addAttribute( "bestFavoriteProductList" , list ) ;
		
		//bestSaleProductList
		sort = Sort.by( Direction.DESC , "saleCount" ) ;
		pageable = PageRequest.of( 0 , 4 , sort ) ;
		pageable2 = PageRequest.of( 1 , 4 , sort ) ;
		list = Arrays.asList( productService.findAll( pageable ) , productService.findAll( pageable2 ) ) ;
		model.addAttribute( "bestSaleProductList" , list ) ;
		
		//bestSaleProductList
		sort = Sort.by( Direction.DESC , "viewCount" ) ;
		pageable = PageRequest.of( 0 , 4 , sort ) ;
		pageable2 = PageRequest.of( 1 , 4 , sort ) ;
		list = Arrays.asList( productService.findAll( pageable ) , productService.findAll( pageable2 ) ) ;
		model.addAttribute( "bestViewCountProductList" , list ) ;
		
		//topBestSaledProductBrandList
		pageable = PageRequest.of( 0 , 6 ) ;
		final Page< Brand > topBestSaledProductBrandList = brandService.findBest( pageable ) ;
		model.addAttribute( "topBestSaledProductBrandList" , topBestSaledProductBrandList ) ;
		
		List< Long > likedProductIdList ;
		final User customer = customerService.getLoggedInCustomer() ;
		likedProductIdList = customer == null ? null : favoriteService.findByCustomerId( customer.getId() ) ;
		model.addAttribute( "likedProductIdList" , likedProductIdList ) ;
		
		return "/user/index" ;
		
	}

	@GetMapping( "/gioi-thieu" )
	public String viewAboutPage() {
		return "/user/about" ;
	}
	
	@GetMapping( "/lien-he" )
	public String viewContactPage() {
		return "/user/contact" ;
	}
	
	@GetMapping( "/tin-tuc" )
	public String viewAllNewsPage(
			Model model
		) {
		final List< News > newsList = newsService.findByIsDeletedFalse() ;
		model.addAttribute( "newsList" , newsList ) ;
		return "/user/news/index" ;
	}
	
	@GetMapping( "/tin-tuc/{id}" )
	public String viewNewsPage(
			Model model ,
			@PathVariable( "id" ) Long _id
		) {
		final News news = newsService.findById( _id ) ;
		model.addAttribute( "news" , news ) ;
		return "/user/news/news" ;
	}
	
	@GetMapping( "/huong-dan" )
	public String viewHelpPage() {
		return "/user/help" ;
	}
	
	@GetMapping( "/dieu-khoan-va-chinh-sach" )
	public String viewTermsAndPolicies() {
		return "/user/terms-and-policies" ;
	}

	@ModelAttribute( name = "categories" )
	List< Category > getCategories() {
		return categoryService.findAll() ;
	}
	
	@ModelAttribute( name = "brands" )
	List< Brand > getBrands() {
		return brandService.findAll() ;
	}

}
