package com.fighting.fpoly_fighting.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.fighting.fpoly_fighting.entity.Category;

@Repository
public interface CategoryDAO extends JpaRepository<Category, Long> {

	Category findBySlugAndIsDeleted(String categorySlug, Boolean isDeleted);

}
