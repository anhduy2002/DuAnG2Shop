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
		final User user = userService.getLoggedInUser() ; /* Lấy thực thể N/D đã đăng nhập */ /* final riêng */
		if( !confirmPassword.equals( newPassword ) ){
			ra.addFlashAttribute( "alert" , "Xác nhận mật khẩu không đúng!" ) ;
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
			ra.addFlashAttribute( "alert" , "Cập nhật mật khẩu thành công!" ) ;
			final SimpleDateFormat dateFormat = new SimpleDateFormat( "dd-MM-yyyy - HH:mm:ss" ) ; 
			final String dateS = dateFormat.format( new Date() ) ;
			try {
				mailService.send( user.getEmail() , "[ ĐÃ CẬP NHẬT MẬT KHẨU ] - G2SHOP" , "Mật khẩu của bạn đã được cập nhật vào " + dateS + "." ) ;
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
			model.addAttribute( "alert" , "Cập nhật tài khoản thất bại!" ) ;
			return "/user/account/update" ;
		}
		try {
			userService.updateAccount( user ) ;
			final User newUser = userService.findById( user.getId() ) ;
			userService.setLoggedInUser( newUser ) ;
			model.addAttribute( "USER" , newUser ) ;
			ra.addFlashAttribute( "alert" , "Cập nhật tài khoản thành công!" ) ;
			final SimpleDateFormat dateFormat = new SimpleDateFormat( "dd-MM-yyyy - HH:mm:ss" ) ; 
			final String dateS = dateFormat.format( new Date() ) ;
			try {
				mailService.send( user.getEmail() , "[ ĐÃ CẬP NHẬT THÔNG TIN ] - G2SHOP" , "Thông tin của bạn đã được cập nhật vào " + dateS + "." ) ;
			} catch ( Exception ex ) {}
		} catch( Exception ex ) {
			ra.addFlashAttribute( "alert" , "Cập nhật tài khoản thất bại. Tên đăng nhập hoặc email có thể đã được sử dụng!" ) ;
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
				ra.addFlashAttribute( "alert" , "Đăng nhập thành công!" ) ;
				return "redirect:/" ;
			}
			ra.addFlashAttribute( "alert" , "Đăng nhập thất bại!" ) ;
			return "redirect:/dang-nhap" ;
		}
		if( _isLoggedOut.isPresent() && _isLoggedOut.get() ) {
			userService.removeLoggedInUser() ;
			ra.addFlashAttribute( "alert" , "Đăng xuất thành công!" ) ;
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
			model.addAttribute( "alert" , "Đăng ký khách hàng thất bại!" ) ;
			return "user/security/sign-up" ;
		}
		if( !confirmPassword.equals( user.getHashPassword() ) ) {
			model.addAttribute( "alert" , "Nhập lại mật khẩu không khớp!" ) ;
			return "user/security/sign-up" ;
		}
		try {
			customerService.signUp( user ) ;
			final SimpleDateFormat dateFormat = new SimpleDateFormat( "dd-MM-yyyy - HH:mm:ss" ) ; 
			final String dateS = dateFormat.format( user.getCreatedDate() ) ;
			try {
				mailService.send( user.getEmail() , "[ CHÀO MỪNG BẠN ĐẾN VỚI G2SHOP ] - G2SHOP" , "Bạn đã đăng ký làm khách hàng của G2Shop vào " + dateS + ".\nChúc bạn mua sắm vui vẻ!" ) ;
			} catch ( Exception ex ) {}
			ra.addFlashAttribute( "alert" , "Đăng ký khách hàng thành công.\nVui lòng đăng nhập!" ) ;
			return "redirect:/dang-nhap" ;
		} catch( Exception ex ) {
			ra.addFlashAttribute( "alert" , "Đăng ký khách hàng thất bại.\nTên đăng nhập, hoặc email, hoặc số điện thoại có thể đã được sử dụng!" ) ;
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
			ra.addFlashAttribute( "alert" , "Yêu cầu thất bại.\nEmail bạn đã nhập không khớp với bất kỳ tài khoản nào!" ) ;
			return "redirect:/dang-nhap/quen-mat-khau" ;
		}
		if( user.getResetPasswordCode() != null ) {
			ra.addFlashAttribute( "alert" , "Lưu ý:\nChúng tôi đã gửi link đặt lại mật khẩu còn hợp lệ cho bạn trước đó.\nVui lòng kiểm tra lại email!" ) ;
			return "redirect:/" ;
		}
		final String s = System.currentTimeMillis() + user.getUsername() ;
		if( user.getResetPasswordCode() == null ) {
			user.setResetPasswordCode( Integer.toHexString( s.hashCode() ) ) ;
			userService.update( user ) ;
			final String subject = "[ ĐẶT LẠI MẬT KHẨU ] - G2SHOP" ;
			final String link = "localhost:8080/dat-lai-mat-khau/" + user.getResetPasswordCode() ;
			final String body = "Link đặt lại mật khẩu: [" + link + "]." ;
			try {
				mailService.send( email , subject , body ) ;
				ra.addFlashAttribute( "alert" , "Yêu cầu thành công.\nChúng tôi đã gửi mail chứa link đặt lại mật khẩu qua email của bạn.\nVui lòng kiểm tra email!" ) ;
				return "redirect:/" ;
			} catch( Exception ex ) {
				ra.addFlashAttribute( "alert" , "Yêu cầu thất bại.\nĐã xảy ra lỗi khi chúng tôi gửi mail đặt lại mật khẩu đến email của bạn!" ) ;
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
			ra.addFlashAttribute( "alert" , "Truy cập trang Đặt lại mật khẩu thất bại.\nLink đặt lại mật khẩu là không hợp lệ hoặc đã bị vô hiệu hóa.\nVui lòng kiểm tra lại!" ) ;
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
			ra.addFlashAttribute( "alert" , "Đặt lại mật khẩu thất bại.\nLink đặt lại mật khẩu là không hợp lệ hoặc đã bị vô hiệu hóa.\nVui lòng kiểm tra lại!" ) ;
			return "redirect:/" ;
		}
		if( !confirmPassword.equals( newPassword ) ){
			ra.addFlashAttribute( "alert" , "Xác nhận mật khẩu không đúng!" ) ;
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
		ra.addFlashAttribute( "alert" , "Đặt lại mật khẩu thành công.\nLink đặt lại mật khẩu bạn vừa sử dụng đã bị vô hiệu hóa.\nVui lòng đăng nhập lại với mật khẩu mới!" ) ;
		return "redirect:/dang-nhap" ;
	}
	
}
