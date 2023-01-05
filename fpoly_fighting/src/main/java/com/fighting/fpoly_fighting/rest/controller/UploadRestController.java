package com.fighting.fpoly_fighting.rest.controller;

import java.io.File;

import javax.websocket.server.PathParam;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fighting.fpoly_fighting.service.UploadService;

@CrossOrigin( "*" )
@RestController

public class UploadRestController {
	
	@Autowired
	UploadService uploadService ;

	@PostMapping( "/rest/upload/images/{folder}" )
	public JsonNode upload( @PathParam( "file" ) MultipartFile file , @PathVariable( "folder" ) String folder ) {
		final File savedFile = uploadService.save( file , folder ) ;
		final ObjectMapper mapper = new ObjectMapper() ;
		final ObjectNode node = mapper.createObjectNode() ;
		node.put( "name" , savedFile.getName() ) ;
		node.put( "size" , savedFile.length() ) ;
		return node ;
	}
	
	@PostMapping( "/rest/upload/images/products/{id}" )
	public JsonNode uploadProductImage( @PathParam( "file" ) MultipartFile file , @PathVariable( "id" ) Long id ) {
		final File savedFile = uploadService.saveProductImage( file , id ) ;
		final ObjectMapper mapper = new ObjectMapper() ;
		final ObjectNode node = mapper.createObjectNode() ;
		node.put( "name" , savedFile.getName() ) ;
		node.put( "size" , savedFile.length() ) ;
		return node ;
	}
	
}
