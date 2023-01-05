package com.fighting.fpoly_fighting.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.dao.BrandDAO;
import com.fighting.fpoly_fighting.entity.Brand;
import com.fighting.fpoly_fighting.service.BrandService;

@Service
public class BrandServiceImpl implements BrandService {
	
	@Autowired
	BrandDAO brandDao;
	
	public List<Brand> findAll() {
		return brandDao.findAll();
	}
	
	@Override
	public Page< Brand > findAll( Pageable pageable ) {
		return brandDao.findAll( pageable ) ;
	}

	@Override
	public Page< Brand > findBest( Pageable pageable ) {
		return brandDao.findBest( pageable ) ;
	}
	
	@Override
	public Brand findById( Long id ) {
		return brandDao.findById( id ).get() ;
	}

	@Override
	public Brand create( Brand brand ) throws Exception {
		if( brand.getId() != null && this.findById( brand.getId() ) != null ) throw new Exception( "Mã thương hiệu đã được sử dụng!" ) ;
		return brandDao.save( brand ) ;
	}

	@Override
	public Brand update( Brand brand ) throws Exception {
		if( brand.getId() != null && this.findById( brand.getId() ) == null ) throw new Exception( "Mã thương hiệu không tồn tại!" ) ;
		return brandDao.save( brand ) ;
	}

	@Override
	public void delete( Long id ) throws Exception {
		if( id != null && this.findById( id ) == null ) throw new Exception( "Mã thương hiệu không tồn tại!" ) ;
		final Brand brand = this.findById( id ) ;
		if( !brand.getIsDeleted() ) throw new Exception( "Không được xóa thương hiệu khi chưa cập nhật isDeleted!" ) ;
		brandDao.deleteById( id ) ;
	}

}
