package com.fighting.fpoly_fighting.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.dao.NewsDAO;
import com.fighting.fpoly_fighting.entity.News;
import com.fighting.fpoly_fighting.service.NewsService;

@Service
public class NewsServiceImpl implements NewsService {

	@Autowired
	NewsDAO newsDao ;

	public List< News > findAll() {
		return newsDao.findAll();
	}

	@Override
	public News findById( Long id ) {
		return newsDao.findById( id ).get() ;
	}

	@Override
	public News create( News news ) throws Exception {
		if( news.getId() != null && this.findById( news.getId() ) != null ) throw new Exception( "Mã tin tức đã được sử dụng!" ) ;
		news.setCreatedDate( new Date() ) ;
		return newsDao.save( news ) ;
	}

	@Override
	public News update( News news ) throws Exception {
		if( news.getId() != null && this.findById( news.getId() ) == null ) throw new Exception( "Mã tin tức không tồn tại!" ) ;
		return newsDao.save( news ) ;
	}

	@Override
	public void delete( Long id ) throws Exception {
		if( id != null && this.findById( id ) == null ) throw new Exception( "Số tin tức không tồn tại!" ) ;
		final News news = this.findById( id ) ;
		if( !news.getIsDeleted() ) throw new Exception( "Không được xóa tin tức khi chưa cập nhật isDeleted!" ) ;
		newsDao.deleteById( id ) ;
	}

	@Override
	public List< News > findByIsShowedOnHomepageTrueAndIsDeletedFalse() {
		return newsDao.findByIsShowedOnHomepageTrueAndIsDeletedFalse() ;
	}
	
	@Override
	public List< News > findByIsDeletedFalse() {
		return newsDao.findByIsDeletedFalse() ;
	}

}
