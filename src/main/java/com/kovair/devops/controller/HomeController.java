package com.kovair.devops.controller;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kovair.devops.model.User;


@Controller
public class HomeController {
	
	@RequestMapping(value="/login", method=RequestMethod.GET)
	public String displayLoginPage() {
		return "login";
	}
	
	@ResponseBody
	@RequestMapping(value="/login", method=RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public String validateUser(@RequestBody User user) {
		//Check the user name and password
		String validUser = "{\"isValidUser\":true}";
		String inValidUser = "{\"isValidUser\":false}";
		if(user != null){
			String userName = user.getUserName(); 
			String password = user.getPassword();
			if(userName.equals("admin") && password.equals("admin")){
				
				return(validUser);
			}
		}
		return(inValidUser);
	}
	
	
}
