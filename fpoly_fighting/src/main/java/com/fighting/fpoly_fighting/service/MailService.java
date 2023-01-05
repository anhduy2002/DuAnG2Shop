package com.fighting.fpoly_fighting.service;

import javax.mail.MessagingException;

import com.fighting.fpoly_fighting.entity.MailInfo;

public interface MailService {
	
	void send( MailInfo mail ) throws MessagingException ;
	
	void send( String to , String subject , String body ) throws MessagingException ;
	
	void queue( MailInfo mail ) ;
	
	void queue( String to , String subject , String body ) ;
	
}
