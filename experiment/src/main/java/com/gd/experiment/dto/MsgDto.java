package com.gd.experiment.dto;

import lombok.Data;

@Data
public class MsgDto {
	private int msgNum;
	private String sender;
	private String receiver;
	private String title;
	private String content;
	private String sendTime; 
	private String readTime;
	private String sendDel;
	private String receiveDel;
}
