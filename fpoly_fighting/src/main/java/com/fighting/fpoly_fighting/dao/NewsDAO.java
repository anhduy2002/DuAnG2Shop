package com.fighting.fpoly_fighting.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.fighting.fpoly_fighting.entity.News;

@Repository
public interface NewsDAO extends JpaRepository< News , Long > {

	@Query( value = "SELECT p FROM News p WHERE p.isShowedOnHomepage IS TRUE AND p.isDeleted IS FALSE" )
	List< News > findByIsShowedOnHomepageTrueAndIsDeletedFalse() ;

	@Query( value = "SELECT p FROM News p WHERE p.isDeleted IS FALSE" )
	List<News> findByIsDeletedFalse() ;
	
}
