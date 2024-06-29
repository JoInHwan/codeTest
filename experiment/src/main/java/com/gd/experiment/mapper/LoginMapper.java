package com.gd.experiment.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LoginMapper {
	
	Map<String,Object> login(Map<String,Object>m);
	
	
}
