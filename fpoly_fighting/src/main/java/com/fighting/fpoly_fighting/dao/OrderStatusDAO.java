package com.fighting.fpoly_fighting.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.fighting.fpoly_fighting.entity.OrderStatus;

@Repository
public interface OrderStatusDAO extends JpaRepository< OrderStatus , Integer > {
}
