package com.fighting.fpoly_fighting.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fighting.fpoly_fighting.entity.Category;
import com.fighting.fpoly_fighting.entity.User;
import com.fighting.fpoly_fighting.service.CategoryService;
import com.fighting.fpoly_fighting.service.CustomerService;
import com.fighting.fpoly_fighting.service.FavoriteService;
import com.fighting.fpoly_fighting.service.MailService;
import com.fighting.fpoly_fighting.service.ProductService;
import com.fighting.fpoly_fighting.service.SessionService;
import com.fighting.fpoly_fighting.service.UserService;

@Controller
public class AccountController {
	
	@Autowired
	MailService mailService ;

	@Autowired
	UserService userService ;
	
	@Autowired
	CustomerService customerService ;
	
	@Autowired
	CategoryService categoryService ;
	
	@Autowired
	ProductService productService ;
	
	@Autowired
	FavoriteService favoriteService ;
	
	@Autowired
	SessionService sessionService ;
	
	@Autowired
	HttpServletRequest req ;
	
	@GetMapping( "/nguoi-dung/doi-mat-khau" )
	public String viewChangePassword(
		) {
		return "/user/account/change-password" ;
	}
	
	@PostMapping( "/nguoi-dung/doi-mat-khau" )
	public String doPostChangePassword(
			@RequestParam( "newPassword" ) String newPassword ,
			@RequestParam( "confirmPassword" ) String confirmPassword ,
			RedirectAttributes ra
		) {
		final User user = userService.getLoggedInUser() ; /* L???y th???c th??? N/D ???? ????ng nh???p */ /* final ri??ng */
		if( !confirmPassword.equals( newPassword ) ){
			ra.addFlashAttribute( "alert" , "X??c nh???n m???t kh???u kh??ng ????ng!" ) ;
			return "redirect:/nguoi-dung/doi-mat-khau" ;
		} else {
			try {
				userService.updatePassword( user , newPassword ) ;
			} catch( Exception ex ) {
				ra.addFlashAttribute( "alert" , ex.getMessage() ) ;
				return "redirect:/nguoi-dung/doi-mat-khau" ;
			}
			final User updatedUser = userService.findById( user.getId() ) ;
			userService.setLoggedInUser( updatedUser ) ;
			ra.addFlashAttribute( "alert" , "C???p nh???t m???t kh???u th??nh c??ng!" ) ;
			final SimpleDateFormat dateFormat = new SimpleDateFormat( "dd-MM-yyyy - HH:mm:ss" ) ; 
			final String dateS = dateFormat.format( new Date() ) ;
			try {
				mailService.send( user.getEmail() , "[ ???? C???P NH???T M???T KH???U ] - G2SHOP" , "M???t kh???u c???a b???n ???? ???????c c???p nh???t v??o " + dateS + "." ) ;
			} catch ( Exception ex ) {}
			return "redirect:/nguoi-dung/doi-mat-khau" ;
		}
	}
	
	@GetMapping( "/nguoi-dung/cap-nhat-tai-khoan" )
	public String viewUpdateAccount(
			Model model
		) {
		model.addAttribute( "USER" , sessionService.get( "USER" ) ) ;
		return "/user/account/update" ;
	}
	
	@PostMapping( "/nguoi-dung/cap-nhat-tai-khoan" )
	public String updateAccount(
			 Model model , 
			 @Valid @ModelAttribute( "USER" ) User user ,
			 BindingResult result , 
			 RedirectAttributes ra
		) {
		if( result.hasErrors() ) {
			System.out.println( result.getAllErrors().get( 0 ) ) ;
			model.addAttribute( "alert" , "C???p nh???t t??i kho???n th???t b???i!" ) ;
			return "/user/account/update" ;
		}
		try {
			userService.updateAccount( user ) ;
			final User newUser = userService.findById( user.getId() ) ;
			userService.setLoggedInUser( newUser ) ;
			model.addAttribute( "USER" , newUser ) ;
			ra.addFlashAttribute( "alert" , "C???p nh???t t??i kho???n th??nh c??ng!" ) ;
			final SimpleDateFormat dateFormat = new SimpleDateFormat( "dd-MM-yyyy - HH:mm:ss" ) ; 
			final String dateS = dateFormat.format( new Date() ) ;
			try {
				mailService.send( user.getEmail() , "[ ???? C???P NH???T TH??NG TIN ] - G2SHOP" , "Th??ng tin c???a b???n ???? ???????c c???p nh???t v??o " + dateS + "." ) ;
			} catch ( Exception ex ) {}
		} catch( Exception ex ) {
			ra.addFlashAttribute( "alert" , "C???p nh???t t??i kho???n th???t b???i. T??n ????ng nh???p ho???c email c?? th??? ???? ???????c s??? d???ng!" ) ;
		}
		return "redirect:/nguoi-dung/cap-nhat-tai-khoan" ;
	}

	@ModelAttribute(name = "categories")
	List<Category> getCategories() {
		return categoryService.findAll();
	}
	
	@GetMapping( "/dang-nhap" )
	public String viewLoginPage( 
			Model model , 
			@RequestParam( "message" ) Optional< String > _message ,
			@RequestParam( "warning" ) Optional< String > _warning ,
			@RequestParam( "byOauth2" ) Optional< Boolean > _byOauth2 ,
			@RequestParam( "isSuccessful" ) Optional< Boolean > _isSuccessful ,
			@RequestParam( "isLoggedOut" ) Optional< Boolean > _isLoggedOut ,
			RedirectAttributes ra
		) {
		if( _isSuccessful.isPresent() ) {
			if( _isSuccessful.get() ) {
				if( !_byOauth2.isPresent() ) {
					userService.setLoggedInUserByUsername( req.getRemoteUser() ) ;
				}
				ra.addFlashAttribute( "alert" , "????ng nh???p th??nh c??ng!" ) ;
				return "redirect:/" ;
			}
			ra.addFlashAttribute( "alert" , "????ng nh???p th???t b???i!" ) ;
			return "redirect:/dang-nhap" ;
		}
		if( _isLoggedOut.isPresent() && _isLoggedOut.get() ) {
			userService.removeLoggedInUser() ;
			ra.addFlashAttribute( "alert" , "????ng xu???t th??nh c??ng!" ) ;
			return "redirect:/" ;
		}
		if( userService.getLoggedInUser() != null ) return "redirect:/" ;
		return "user/security/login" ;
	}
	
	@GetMapping( "/dang-ky" )
	public String viewSignUpPage( 
			Model model
		) {
		if( userService.getLoggedInUser() != null ) return "redirect:/" ;
		model.addAttribute( "newUser" , new User() ) ;
		return "user/security/sign-up" ;
	}
	
	@PostMapping( "/dang-ky" )
	public String signUp(
			 Model model , 
			 @Valid @ModelAttribute( "newUser" ) User user ,
			 BindingResult result ,
			 @RequestParam( "confirmPassword" ) String confirmPassword ,
			 RedirectAttributes ra
		) {
		if( userService.getLoggedInUser() != null ) return "redirect:/" ;
		if( result.hasErrors() ) {
			model.addAttribute( "alert" , "????ng k?? kh??ch h??ng th???t b???i!" ) ;
			return "user/security/sign-up" ;
		}
		if( !confirmPassword.equals( user.getHashPassword() ) ) {
			model.addAttribute( "alert" , "Nh???p l???i m???t kh???u kh??ng kh???p!" ) ;
			return "user/security/sign-up" ;
		}
		try {
			customerService.signUp( user ) ;
			final SimpleDateFormat dateFormat = new SimpleDateFormat( "dd-MM-yyyy - HH:mm:ss" ) ; 
			final String dateS = dateFormat.format( user.getCreatedDate() ) ;
			try {
				mailService.send( user.getEmail() , "[ CH??O M???NG B???N ?????N V???I G2SHOP ] - G2SHOP" , "B???n ???? ????ng k?? l??m kh??ch h??ng c???a G2Shop v??o " + dateS + ".\nCh??c b???n mua s???m vui v???!" ) ;
			} catch ( Exception ex ) {}
			ra.addFlashAttribute( "alert" , "????ng k?? kh??ch h??ng th??nh c??ng.\nVui l??ng ????ng nh???p!" ) ;
			return "redirect:/dang-nhap" ;
		} catch( Exception ex ) {
			ra.addFlashAttribute( "alert" , "????ng k?? kh??ch h??ng th???t b???i.\nT??n ????ng nh???p, ho???c email, ho???c s??? ??i???n tho???i c?? th??? ???? ???????c s??? d???ng!" ) ;
			return "redirect:/dang-ky" ;
		}
	}
	
	@GetMapping( { "/oauth2/login/success" } )
	public String loginByOauth2Success( 
			OAuth2AuthenticationToken oauth2AuthenticationToken 
		) {
		try {
			userService.setLoggedInUserByOAuth2AuthenticationToken( oauth2AuthenticationToken ) ;
			return "redirect:/dang-nhap?isSuccessful=true&&byOauth2=true" ;
		} catch( Exception ex ) {
			return "redirect:/" ;
		}
	}
	
	@GetMapping( "/dang-nhap/quen-mat-khau" )
	public String viewForgetPasswordPage(
		) {
		if( userService.getLoggedInUser() != null ) return "redirect:/" ;
		return "/user/security/forget-password" ;
	}
	
	@PostMapping( "/dang-nhap/quen-mat-khau" )
	public String askForResettingPassword(
			@RequestParam( "email" ) String email ,
			RedirectAttributes ra
		) {
		if( userService.getLoggedInUser() != null ) return "redirect:/" ;
		final User user = userService.findByEmail( email ) ;
		if( user == null ) {
			ra.addFlashAttribute( "alert" , "Y??u c???u th???t b???i.\nEmail b???n ???? nh???p kh??ng kh???p v???i b???t k??? t??i kho???n n??o!" ) ;
			return "redirect:/dang-nhap/quen-mat-khau" ;
		}
		if( user.getResetPasswordCode() != null ) {
			ra.addFlashAttribute( "alert" , "L??u ??:\nCh??ng t??i ???? g???i link ?????t l???i m???t kh???u c??n h???p l??? cho b???n tr?????c ????.\nVui l??ng ki???m tra l???i email!" ) ;
			return "redirect:/" ;
		}
		final String s = System.currentTimeMillis() + user.getUsername() ;
		if( user.getResetPasswordCode() == null ) {
			user.setResetPasswordCode( Integer.toHexString( s.hashCode() ) ) ;
			userService.update( user ) ;
			final String subject = "[ ?????T L???I M???T KH???U ] - G2SHOP" ;
			final String link = "localhost:8080/dat-lai-mat-khau/" + user.getResetPasswordCode() ;
			final String body = "Link ?????t l???i m???t kh???u: [" + link + "]." ;
			try {
				mailService.send( email , subject , body ) ;
				ra.addFlashAttribute( "alert" , "Y??u c???u th??nh c??ng.\nCh??ng t??i ???? g???i mail ch???a link ?????t l???i m???t kh???u qua email c???a b???n.\nVui l??ng ki???m tra email!" ) ;
				return "redirect:/" ;
			} catch( Exception ex ) {
				ra.addFlashAttribute( "alert" , "Y??u c???u th???t b???i.\n???? x???y ra l???i khi ch??ng t??i g???i mail ?????t l???i m???t kh???u ?????n email c???a b???n!" ) ;
			}
		}
		return "redirect:/dang-nhap/quen-mat-khau" ;
	}
	
	@GetMapping( "/dat-lai-mat-khau/{resetPasswordCode}" )
	public String viewResetPasswordPage(
			Model model ,
			@PathVariable( "resetPasswordCode" ) String _resetPasswordCode ,
			RedirectAttributes ra
		) {
		if( userService.getLoggedInUser() != null ) return "redirect:/" ;
		final User user = userService.findByResetPasswordCode( _resetPasswordCode ) ;
		if( user == null ) {
			ra.addFlashAttribute( "alert" , "Truy c???p trang ?????t l???i m???t kh???u th???t b???i.\nLink ?????t l???i m???t kh???u l?? kh??ng h???p l??? ho???c ???? b??? v?? hi???u h??a.\nVui l??ng ki???m tra l???i!" ) ;
			return "redirect:/" ;
		}
		model.addAttribute( "resetPasswordCode" , user.getResetPasswordCode() ) ;
		return "/user/security/reset-password" ;
	}
	
	@PostMapping( "/dat-lai-mat-khau" )
	public String viewResetPasswordPage(
			@RequestParam( "resetPasswordCode" ) String resetPasswordCode ,
			@RequestParam( "newPassword" ) String newPassword ,
			@RequestParam( "confirmPassword" ) String confirmPassword ,
			RedirectAttributes ra
		) {
		if( userService.getLoggedInUser() != null ) return "redirect:/" ;
		final User user = userService.findByResetPasswordCode( resetPasswordCode ) ;
		if( user == null ) {
			ra.addFlashAttribute( "alert" , "?????t l???i m???t kh???u th???t b???i.\nLink ?????t l???i m???t kh???u l?? kh??ng h???p l??? ho???c ???? b??? v?? hi???u h??a.\nVui l??ng ki???m tra l???i!" ) ;
			return "redirect:/" ;
		}
		if( !confirmPassword.equals( newPassword ) ){
			ra.addFlashAttribute( "alert" , "X??c nh???n m???t kh???u kh??ng ????ng!" ) ;
			return "redirect:/dat-lai-mat-khau/" + resetPasswordCode ;
		} else {
			try {
				userService.updatePassword( user , newPassword ) ;
			} catch( Exception ex ) {
				ra.addFlashAttribute( "alert" , ex.getMessage() ) ;
				return "redirect:/dat-lai-mat-khau/" + resetPasswordCode ;
			}
		}
		final User updatedUser = userService.findById( user.getId() ) ;
		updatedUser.setResetPasswordCode( null ) ;
		userService.update( updatedUser ) ;
		ra.addFlashAttribute( "alert" , "?????t l???i m???t kh???u th??nh c??ng.\nLink ?????t l???i m???t kh???u b???n v???a s??? d???ng ???? b??? v?? hi???u h??a.\nVui l??ng ????ng nh???p l???i v???i m???t kh???u m???i!" ) ;
		return "redirect:/dang-nhap" ;
	}
	
}
