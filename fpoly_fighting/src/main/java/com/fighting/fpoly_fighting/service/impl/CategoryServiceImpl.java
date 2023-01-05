package com.fighting.fpoly_fighting.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.dao.CategoryDAO;
import com.fighting.fpoly_fighting.entity.Category;
import com.fighting.fpoly_fighting.service.CategoryService;

@Service
public class CategoryServiceImpl implements CategoryService {

	@Autowired
	CategoryDAO categoryDao;

	public List<Category> findAll() {
		return categoryDao.findAll();
	}

	@Override
	public Category findBySlug( String categorySlug ) {
		return categoryDao.findBySlugAndIsDeleted(categorySlug, Boolean.FALSE);
	}

	@Override
	public Category findById( Long id ) {
		return categoryDao.findById( id ).get() ;
	}

	@Override
	public Category create( Category category ) throws Exception {
		if( category.getId() != null && this.findById( category.getId() ) != null ) throw new Exception( "Mã loại sản phẩm đã được sử dụng!" ) ;
		return categoryDao.save( category ) ;
	}

	@Override
	public Category update( Category category ) throws Exception {
		if( category.getId() != null && this.findById( category.getId() ) == null ) throw new Exception( "Mã loại sản phẩm không tồn tại!" ) ;
		return categoryDao.save( category ) ;
	}

	@Override
	public void delete( Long id ) throws Exception {
		if( id != null && this.findById( id ) == null ) throw new Exception( "Mã loại sản phẩm không tồn tại!" ) ;
		final Category category = this.findById( id ) ;
		if( !category.getIsDeleted() ) throw new Exception( "Không được xóa loại sản phẩm khi chưa cập nhật isDeleted!" ) ;
		categoryDao.deleteById( id ) ;
	}

}
