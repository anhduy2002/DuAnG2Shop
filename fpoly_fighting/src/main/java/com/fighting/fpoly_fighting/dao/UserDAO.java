package com.fighting.fpoly_fighting.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.fighting.fpoly_fighting.entity.User;

@Repository
public interface UserDAO extends JpaRepository<User, Long> {

	User findByUsername( String username ) ;

	User findByPhone( String phone ) ;

	User findByEmail( String email ) ;
	
	User findByResetPasswordCode( String resetPasswordCode ) ;

	@Query(value = "UPDATE users SET isEnabled = true where id = ?", nativeQuery = true)
	void isEnabledTrue(Long id);
	
	List<User> findByIsDeletedAndIsEnabled(Boolean isDeleted, Boolean isEnabled);
	
	@Modifying(clearAutomatically = true)
	@Query( value = "UPDATE users SET isDeleted = 1 where username = ?1 ", nativeQuery = true)
	void deletedLogic( String username );
	
	@Query( "select p from User p where p.role.id != 1 " )
	List< User > findAllStaff() ;

	@Query( "select p from User p where p.role.id = 1 " )
	List< User > findAllCustomer() ;

	

}
