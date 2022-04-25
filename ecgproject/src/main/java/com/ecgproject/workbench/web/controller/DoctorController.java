package com.ecgproject.workbench.web.controller;

import com.ecgproject.settings.domain.User;
import com.ecgproject.settings.service.UserService;
import com.ecgproject.workbench.domain.Doctor;
import com.ecgproject.workbench.service.DoctorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.print.Doc;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class DoctorController {

    @Autowired
    private DoctorService doctorService;

    @Autowired
    private UserService userService;

    @RequestMapping("/workbench/doctor/index.do")
    public String index(HttpServletRequest request){
        //调service查所有用户
        List<User> userList = userService.queryAllUsers();
        //数据放request里
        request.setAttribute("userList",userList);
        //请求转发到患者列表的主页面
        return "workbench/doctor/index";
    }

    @RequestMapping("/workbench/doctor/queryDoctorByConditionForPage.do")
    public @ResponseBody Object queryDoctorByConditionForPage(String name, int pageNo, int pageSize){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调service查数据
        List<Doctor> doctorList = doctorService.queryDoctorByConditionForPage(map);
        int totalRows = doctorService.queryCountOfByCondition(map);

        //根据查询结果生成相应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("doctorList",doctorList);
        retMap.put("totalRows",totalRows);

        return retMap;

    }
}
