package com.fighting.fpoly_fighting.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.fighting.fpoly_fighting.entity.Role;

@Repository
public interface RoleDAO extends JpaRepository<Role, Long> {
	Role findByName( String name ) ;
}
