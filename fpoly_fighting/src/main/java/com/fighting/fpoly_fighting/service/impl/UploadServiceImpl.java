package com.fighting.fpoly_fighting.service.impl;

import java.io.File;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fighting.fpoly_fighting.service.UploadService;

@Service
public class UploadServiceImpl implements UploadService{
	
	@Autowired
	ServletContext app ;
	
	@Override
	public File save( MultipartFile file , String folder ) {
		final File dir = new File( app.getRealPath( "/images/" + folder ) ) ;
		if( !dir.exists() ) {
			dir.mkdir() ;
		}
		final String s = System.currentTimeMillis() + file.getOriginalFilename() ;
		final String name = Integer.toHexString( s.hashCode() ) + s.substring( s.lastIndexOf( "." ) ) ;
		try {
			final File savedFile = new File( dir , name ) ;
			System.out.println( file ) ;
			file.transferTo( savedFile ) ;
			return savedFile ;
		} catch( Exception ex ) {
			throw new RuntimeException( ex ) ;
		}
	}

	@Override
	public File saveProductImage( MultipartFile file, Long id ) {
		final File dir = new File( app.getRealPath( "/images/products/" + id ) ) ;
		if( !dir.exists() ) {
			dir.mkdir() ;
		}
		final String s = System.currentTimeMillis() + file.getOriginalFilename() ;
		final String name = Integer.toHexString( s.hashCode() ) + s.substring( s.lastIndexOf( "." ) ) ;
		try {
			final File savedFile = new File( dir , name ) ;
			System.out.println( file ) ;
			file.transferTo( savedFile ) ;
			return savedFile ;
		} catch( Exception ex ) {
			throw new RuntimeException( ex ) ;
		}
	}
}
