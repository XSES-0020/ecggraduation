package com.ecgproject.workbench.web.controller;

import com.ecgproject.workbench.domain.Appointment;
import com.ecgproject.workbench.service.AppointmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class AppointmentController {
    @Autowired
    private AppointmentService appointmentService;

    @RequestMapping("/workbench/appointment/index.do")
    public String index(){
        return "workbench/appointment/index";
    }

    @RequestMapping("/workbench/appointment/queryAppointmentByConditionForPage.do")
    public @ResponseBody Object queryAppointmentByConditionForPage(String take, int pageNo, int pageSize){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("status",take);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调service查数据
        List<Appointment> appointmentList = appointmentService.queryAppointmentByConditionForPage(map);
        int totalRows = appointmentService.queryAppointmentCountOfByCondition(map);


        //根据查询结果生成相应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("appointmentList",appointmentList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }
}
