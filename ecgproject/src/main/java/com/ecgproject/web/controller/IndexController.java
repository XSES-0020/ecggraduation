package com.ecgproject.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {
    /*
        分配首页url http://127.0.0.1:8080/ecgproject/
        为了简便协议://ip:port/应用名称必须省掉，用/代表根目录
     */
    @RequestMapping("/")
    public String index(){
        //请求转发
        return "index";//页面资源路径
    }
}
