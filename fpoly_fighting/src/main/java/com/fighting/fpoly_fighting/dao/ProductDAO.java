package com.fighting.fpoly_fighting.dao;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.fighting.fpoly_fighting.entity.Category;
import com.fighting.fpoly_fighting.entity.Product;

@Repository
public interface ProductDAO extends JpaRepository<Product, Long> {

	// Phân trang
	Page<Product> findByIsDeletedAndQuantityGreaterThan(Boolean isDeleted, Integer quantity, Pageable pageable);

	// lấy ra 1 sản phẩm
	Product findBySlug(String slug);

	// danh sách sản phẩm tìm theo loại
	@Query(value = "SELECT products.* FROM products join categories on products.categoryId = categories.id "
			+ "WHERE categories.slug = ?", nativeQuery = true)
	List<Product> findByCategorySlug(String slug);

	@Query(value = "SELECT * FROM products WHERE name LIKE %:key%", nativeQuery = true)
	Page<Product> findByKeywords(String key, Pageable pageable);

	Page<Product> findByCategoryIdAndIsDeletedAndQuantityGreaterThan(Long categoryId, Boolean isDeleted, Integer quantity,
			PageRequest of);

	List<Product> findByCategoryAndSlugNotAndIsDeletedAndQuantityGreaterThan(Category category, String slug,
			Boolean isDeleted, Integer quantity);
	
	/*
	@Query("SELECT p FROM Product p WHERE p.name LIKE %?1%"
            + " OR p.brand LIKE %?1%"
            + " OR p.madein LIKE %?1%"
            + " OR CONCAT(p.price, '') LIKE %?1%")
    public List<Product> search(String keyword);
    */

	@Query( value = "SELECT p FROM Product p WHERE "
			+ "( ( :isFilterCategoriesEnabled = false ) OR ( p.category.id IN (:filter_categories) ) ) AND "
			+ "( ( :isFilterBrandsEnabled = false ) OR ( p.brand.id IN (:filter_brands) ) ) AND "
			+ "( ( :likedCustomerId < 0L ) OR ( p.id IN ( SELECT distinct f.product.id FROM Favorite f WHERE f.customer.id = :likedCustomerId AND f.isCanceled = false ) ) ) AND "
			+ "( ( :boughtCustomerId < 0L ) OR ( p.id IN ( SELECT distinct d.product.id FROM OrderDetail d , Order o WHERE o.customer.id = :boughtCustomerId AND o.orderStatus.id > 0L AND o.id = d.order.id ) ) ) AND "
			+ "( ( :min < 0 ) OR ( :min <= p.price / 100 * ( 100 - p.discount ) ) ) AND "
			+ "( ( :max < 0 ) OR ( :max >= p.price / 100 * ( 100 - p.discount ) ) ) AND"
			+ "( ( LEN( :search ) = 0  ) OR ( p.name LIKE %:search% ) OR ( p.category.name LIKE %:search% ) OR ( p.brand.name LIKE %:search% ) )" )
	Page<Product> findByFilter( 
		Long[] filter_categories , 
		Long[] filter_brands , 
		boolean isFilterCategoriesEnabled , 
		boolean isFilterBrandsEnabled ,
		Long likedCustomerId ,
		Long boughtCustomerId ,
		int min ,
		int max ,
		String search ,
		Pageable pageable
	) ;

	@Query( value = "SELECT p FROM Product p" )
	Page< Product > findAll( Pageable pageable ) ;

	@Query( value = "SELECT p FROM Product p WHERE p.id != :productId AND p.category.id = :categoryId" )
	Page<Product> findByRelatedProduct( Long productId , Long categoryId , Pageable pageable ) ;
	
	@Query( value = "SELECT p.id FROM Product p ORDER BY p.id" )
	List< Long > findAllProductIds() ;

	List<Product> findAllByOrderByLikesCountDesc();

	@Query( value = "SELECT p FROM Product p WHERE p.category.id = :categoryId" )
	List< Product > findByCategoryId( Long categoryId ) ;

}
