package com.ecgproject.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ChartController {

    @RequestMapping("/workbench/chart/machine/index.do")
    public String index(){
        //跳转页面
        return "workbench/chart/machine/index";
    }
}
