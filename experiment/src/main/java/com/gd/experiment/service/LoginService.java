package com.gd.experiment.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gd.experiment.mapper.LoginMapper;

@Service
public class LoginService {
	@Autowired LoginMapper loginMapper;
		
}
