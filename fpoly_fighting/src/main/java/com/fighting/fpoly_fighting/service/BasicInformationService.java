package com.fighting.fpoly_fighting.service;

import com.fighting.fpoly_fighting.entity.BasicInformation;

public interface BasicInformationService {

	BasicInformation findById(Long id);

	BasicInformation update(BasicInformation basicInformation);
}
