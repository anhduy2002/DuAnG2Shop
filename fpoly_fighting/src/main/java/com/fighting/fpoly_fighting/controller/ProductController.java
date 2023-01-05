package com.fighting.fpoly_fighting.controller;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Optional;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fighting.fpoly_fighting.entity.Brand;
import com.fighting.fpoly_fighting.entity.Category;
import com.fighting.fpoly_fighting.entity.Favorite;
import com.fighting.fpoly_fighting.entity.Product;
import com.fighting.fpoly_fighting.entity.User;
import com.fighting.fpoly_fighting.service.BrandService;
import com.fighting.fpoly_fighting.service.CategoryService;
import com.fighting.fpoly_fighting.service.CustomerService;
import com.fighting.fpoly_fighting.service.FavoriteService;
import com.fighting.fpoly_fighting.service.OrderService;
import com.fighting.fpoly_fighting.service.ProductService;
import com.fighting.fpoly_fighting.service.SessionService;
import com.fighting.fpoly_fighting.service.UserService;

@Controller
public class ProductController {

	@Autowired
	SessionService sessionService;

	@Autowired
	UserService userService;
	
	@Autowired
	CustomerService customerService;
	
	@Autowired
	ProductService productService;
	
	@Autowired
	FavoriteService favoriteService;

	@Autowired
	CategoryService categoryService;
	
	@Autowired
	BrandService brandService;
	
	@Autowired
	OrderService orderService ;
	
	@Autowired
	HttpServletRequest req;

	@GetMapping( "san-pham" )
	public String list( 
			Model model ,
			@RequestParam( name = "categories" ) Optional< Long[] > _categories ,
			@RequestParam( name = "brands" ) Optional< Long[] > _brands ,
			@RequestParam( name = "is-only-liked" ) Optional< Boolean > _is_only_liked ,
			@RequestParam( name = "is-only-bought" ) Optional< Boolean > _is_only_bought ,
			@RequestParam( name = "price-range" ) Optional< Integer > _price_range ,
			@RequestParam( name = "is-sort-enabled" ) Optional< Boolean > _is_sort_enabled ,
			@RequestParam( name = "sort-by" ) Optional< String > _sortBy ,
			@RequestParam( name = "sort-dir" ) Optional< String > _sortDir ,
			@RequestParam( name = "is-filter-new" ) Optional< Boolean > _is_filter_new ,
			@RequestParam( name = "search" ) Optional< String > _search ,
			@RequestParam( name = "page" ) Optional< Integer > _page
		) {
		final boolean isFilterNew = _is_filter_new.isPresent() ? true : false ;
		final Long[] categories = _categories.isPresent() ? ( _categories.get()[ 0 ] == 0 ? null : ( isFilterNew ? _categories.get() : null ) ) : ( isFilterNew ? null : sessionService.get( "filter_categories" ) ) ;
		final Long[] brands = isFilterNew ? ( _brands.isPresent() ? _brands.get() : null ) 
				:  sessionService.get( "filter_brands" ) ;
		Long likedCustomerId = -1L ;
		Long boughtCustomerId = -1L ;
		final Boolean isOnlyLiked = isFilterNew ? ( _is_only_liked.isPresent() ? _is_only_liked.get() : null )
				: sessionService.get( "filter_is_only_liked" ) ;
		final Boolean isOnlyBought = isFilterNew ? ( _is_only_bought.isPresent() ? _is_only_bought.get() : null )
				: sessionService.get( "filter_is_only_bought" ) ;
		final Integer priceRange = isFilterNew ? ( _price_range.isPresent() ? _price_range.get() : null )
				: sessionService.get( "filter_price_range" ) ;
		sessionService.set( "is_sort_enabled" , false );
		final boolean isSortEnabled = isFilterNew ? ( _is_sort_enabled.isPresent() ? _is_sort_enabled.get() : false  )
				: sessionService.get( "is_sort_enabled" );
		String sortBy = isFilterNew ? ( _sortBy.isPresent() ? _sortBy.get() : null )
				: sessionService.get( "sort_by" ) ;
		sortBy = isSortEnabled ? sortBy : null ;
		final String s_sortDir = isFilterNew ? ( _sortDir.isPresent() ? _sortDir.get() : "0" ) 
				: sessionService.get( "sort_dir" ) ;
		Direction sortDir = s_sortDir == null ? Direction.ASC : ( s_sortDir.equals( "0" ) ? Direction.ASC : Direction.DESC ) ;
		
		final String search = _search.isPresent() ? _search.get().trim() : ( sessionService.get( "search" ) == null ? "" :  sessionService.get( "search" ) ) ;
		final Integer page = _page.isPresent() ? _page.get() - 1 : 0 ;
		sessionService.set( "filter_categories" , categories ) ;
		sessionService.set( "filter_brands" , brands ) ;
		sessionService.set( "filter_is_only_liked" , isOnlyLiked ) ;
		sessionService.set( "filter_is_only_bought" , isOnlyBought ) ;
		sessionService.set( "sort_by" , sortBy ) ;
		sessionService.set( "sort_dir" , s_sortDir ) ;
		sessionService.set( "filter_price_range" , priceRange ) ;
		sessionService.set( "is_sort_enabled" , isSortEnabled ) ;
		sessionService.set( "search" , search ) ;
		sessionService.set( "page" , page ) ;
		sessionService.set( "main_category" , categories == null ? null : ( categories.length == 1 ?  categoryService.findById( categories[ 0 ] ) : null ) ) ;
		final User customer = customerService.getLoggedInCustomer() ;
		if( isOnlyLiked != null ) {
			if( customer != null && isOnlyLiked ) {
				likedCustomerId = customer.getId() ;
			}
		}
		if( isOnlyBought != null ) {
			if( customer != null && isOnlyBought ) {
				boughtCustomerId = customer.getId() ;
			}
		}
		int max = -1 ;
		int min = -1 ;
		if( priceRange != null ) {
			switch( priceRange ) {
				case 2 :
					min = 0 ;
					max = 1000000 - 1 ;
					break ;
				case 3 :
					min = 1000000 ;
					max = 2000000 - 1 ;
					break ;
				case 4 :
					min = 2000000 ;
					max = 3000000 - 1 ;
					break ;
				case 5 :
					min = 3000000 ;
					max = 5000000 - 1 ;
					break ;
				case 6 :
					min = 5000000 ;
					max = 7000000 - 1 ;
					break ;
				case 7 :
					min = 7000000 ;
					max = 10000000 - 1 ;
					break ;
				case 8 :
					min = 10000000 ;
					max = 15000000 - 1 ;
					break ;
				case 9 :
					min = 15000000 ;
					max = 20000000 - 1 ;
					break ;
				case 10 :
					min = 20000000 ;
					max = -1 ;
			} ;
		}
		if( sortBy != null && ( sortBy.equals( "likesCount" ) || sortBy.equals( "discount" ) || sortBy.equals( "saleCount" ) || sortBy.equals( "viewCount" ) ) ) {
			sortDir = sortDir.isAscending() ? Direction.DESC : Direction.ASC ;
		}
		final Sort sort = sortBy == null ? null : Sort.by( sortDir , sortBy ) ;
		final Pageable pageable = sort == null ? PageRequest.of( page , 8 ) : PageRequest.of( page , 8 , sort ) ;
		final Page< Product > productPage = productService.findByFilter( categories , brands , categories != null , brands != null , likedCustomerId , boughtCustomerId , min , max , search , pageable ) ;
		model.addAttribute( "productPage", productPage ) ;
		return "/user/product/list" ;
	}
	
	@GetMapping( "/san-pham/{category}" )
	public String listProductByCategory( 
			Model model , 
			@PathVariable( "category" ) String _category 
		) {
		final Category category = categoryService.findBySlug( _category ) ;
		return "forward:/san-pham?is-filter-new=true&categories=" + category.getId()  ;
	}
	
	@GetMapping( "/san-pham/{category}/{product}" )
	public String viewProductDetails( 
			Model model, 
			@PathVariable( "category" ) String _category ,
			@PathVariable( "product" ) String _product ,
			RedirectAttributes ra 
		) {
		Product product = productService.findSlug( _product ) ;
		try {
			productService.increaseViewCount( product.getId() ) ;
			product = productService.findById( product.getId() ) ;
		} catch( Exception ex ) {
		}
		final Pageable pageable = PageRequest.of( 0 , 4 ) ;
		final Pageable pageable2 = PageRequest.of( 1 , 4 ) ;
		model.addAttribute( "product" , product ) ;
		model.addAttribute( "productImageNames" , Arrays.asList( product.getImageName() , product.getImage1Name() , product.getImage2Name() , product.getImage3Name() , product.getImage4Name() , product.getImage5Name() ) ) ;
		model.addAttribute( "relatedProductList" , Arrays.asList( 
				productService.findByRelatedProduct( product.getId() , product.getCategory().getId() , pageable ) ,
				productService.findByRelatedProduct( product.getId() , product.getCategory().getId() , pageable2 ) 
		) ) ;
		return "/user/product/details" ;
	}
	
	@GetMapping( "/khach-hang/thich-san-pham" )
	public String updateAccount(
			 Model model , 
			 @RequestParam( name = "productId" ) Long productId
		) {
		final User USER = sessionService.get( "USER" ) ;
		final Favorite favorite = favoriteService.findByCustomerIdAndProductId( USER.getId() , productId ) ;
		final Product product = productService.findById( productId ) ;
		if( favorite == null ) {
			 final Favorite newFavorite = new Favorite() ;
			 newFavorite.setCreatedDate( new Date() ) ;
			 newFavorite.setCustomer( USER ) ;
			 newFavorite.setIsCanceled( false ) ;
			 newFavorite.setProduct( product ) ;
			 favoriteService.create( newFavorite ) ;
		} else {
			favorite.setIsCanceled( !favorite.getIsCanceled() ) ;
			favoriteService.update( favorite ) ;
		}
		return "redirect:/san-pham/" + product.getCategory().getSlug() + "/" + product.getSlug() ;
	}
	
	@ModelAttribute( name = "categories" )
	List< Category > getCategories() {
		return categoryService.findAll() ;
	}
	
	@ModelAttribute( name = "brands" )
	List< Brand > getBrands() {
		return brandService.findAll() ;
	}
	
	@ModelAttribute( name = "likedProductIdList" )
	List< Long > getLikedProductIdList(){
		final User USER = sessionService.get( "USER" ) ;
		if( USER == null ) return null ; 
		return favoriteService.findByCustomerId( USER.getId() ) ;
	}

}
