package com.fighting.fpoly_fighting.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.fighting.fpoly_fighting.entity.BasicInformation;

@Repository
public interface BasicInformationDAO extends JpaRepository<BasicInformation, Long> {
	
}
