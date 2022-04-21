package com.ecgproject.settings.web.controller;

import com.ecgproject.settings.service.StaffService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

@Controller
public class StaffController {

    @Autowired
    private StaffService staffService;


}
