package com.fighting.fpoly_fighting.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fighting.fpoly_fighting.dao.BasicInformationDAO;
import com.fighting.fpoly_fighting.entity.BasicInformation;
import com.fighting.fpoly_fighting.service.BasicInformationService;

@Service
public class BasicInformationServiceImpl implements BasicInformationService {
	
	@Autowired
	BasicInformationDAO basicInformationDAO;

	@Override
	public BasicInformation findById(Long id) {
		return basicInformationDAO.findById(id).get();
	}

	@Override
	public BasicInformation update(BasicInformation basicInformation) {
		return basicInformationDAO.save(basicInformation);
	}

}
