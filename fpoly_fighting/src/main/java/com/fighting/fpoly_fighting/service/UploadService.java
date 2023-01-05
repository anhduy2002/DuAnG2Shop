package com.fighting.fpoly_fighting.service;

import java.io.File;

import org.springframework.web.multipart.MultipartFile;

public interface UploadService {
	
	File save( MultipartFile file , String folder ) ;

	File saveProductImage( MultipartFile file , Long id ) ;
	
}
