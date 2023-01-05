package com.fighting.fpoly_fighting.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.dao.ProductDAO;
import com.fighting.fpoly_fighting.entity.Product;
import com.fighting.fpoly_fighting.service.ProductService;
import com.fighting.fpoly_fighting.service.SessionService;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    ProductDAO productDao;
    
    @Autowired
    SessionService sessionService ;
    
    @Override
    public List<Product> findAll() {
        return productDao.findAll();
    }

    @Override
    public Product findSlug(String slug) {
        return productDao.findBySlug(slug);
    }
    
    @Override
    public List< Product > findByCategoryId( Long categoryId ) {
        return productDao.findByCategoryId( categoryId ) ;
    }

    @Override
    public List<Product> findByCategorySlug(String slug) {
        return productDao.findByCategorySlug(slug);
    }

	@Override
	public Page<Product> findByRelatedProduct( Long productId , Long categoryId , Pageable pageable ) {
		return productDao.findByRelatedProduct( productId , categoryId , pageable ) ;
	}

	@Override
	public Page<Product> findByFilter( 
			Long[] filter_categories , 
			Long[] filter_brands , 
			boolean isFilterCategoriesEnabled , 
			boolean isFilterBrandsEnabled ,
			Long likedCustomerId ,
			Long boughtCustomerId ,
			int min ,
			int max ,
			String search ,
			Pageable pageable ) {
		return productDao.findByFilter( 
			filter_categories , 
			filter_brands , 
			isFilterCategoriesEnabled , 
			isFilterBrandsEnabled ,
			likedCustomerId ,
			boughtCustomerId ,
			min ,
			max ,
			search ,
			pageable ) ;
	}

	@Override
	public List< Product > findAll( Pageable pageable ) {
		return productDao.findAll( pageable ).getContent() ;
	}

	@Override
	public Product findById( Long productId ) {
		return productDao.findById( productId ).get() ;
	}
	
	@Override
	public Product create( Product product ) throws Exception {
		if( product.getId() != null && this.findById( product.getId() ) != null ) throw new Exception( "Mã sản phẩm đã được sử dụng!" ) ;
		return productDao.save( product ) ;
	}

	@Override
	public Product update( Product product ) throws Exception {
		if( product.getId() != null && this.findById( product.getId() ) == null ) throw new Exception( "Mã sản phẩm không tồn tại!" ) ;
		return productDao.save( product ) ;
	}

	@Override
	public void delete( Long id ) throws Exception {
		if( id != null && this.findById( id ) == null ) throw new Exception( "Mã sản phẩm không tồn tại!" ) ;
		final Product product = this.findById( id ) ;
		if( !product.getIsDeleted() ) throw new Exception( "Không được xóa sản phẩm khi chưa cập nhật isDeleted!" ) ;
		productDao.deleteById( id ) ;
	}

	@Override
	public List< Long > findAllProductIds() {
		return productDao.findAllProductIds() ;
	}

	@Override
	public void increaseViewCount( Long id ) throws Exception {
		if( id != null && this.findById( id ) == null ) throw new Exception( "Không tìm thấy sản phẩm!" ) ;
		final Product product = this.findById( id ) ;
		final List< Long > viewedProductIdList = sessionService.get( "viewedProductIdList" ) ;
		if( viewedProductIdList.contains( product.getId() ) ) return ;
		viewedProductIdList.add( product.getId() ) ;
		sessionService.set( "viewedProductIdList" , viewedProductIdList ) ;
		product.setViewCount( product.getViewCount() + 1 ) ;
		this.update( product ) ;
	}

	@Override
	public List<Product> findAllByOrderByLikesCountDesc() {
		return productDao.findAllByOrderByLikesCountDesc();
	}

}
