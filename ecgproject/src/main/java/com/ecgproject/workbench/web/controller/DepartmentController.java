package com.ecgproject.workbench.web.controller;

import com.ecgproject.workbench.domain.Department;
import com.ecgproject.workbench.domain.Doctor;
import com.ecgproject.workbench.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    @RequestMapping("/workbench/department/index.do")
    public String index(){
        return "workbench/department/index";
    }

    @RequestMapping("/workbench/department/queryDepartmentByConditionForPage.do")
    public @ResponseBody Object queryDepartmentByConditionForPage(String name, int pageNo, int pageSize){
        /*//调试
        System.out.println("******************************");
        System.out.println(pageNo);
        System.out.println("******************************");*/

        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调service查数据
        List<Department> departmentList = departmentService.queryDepartmentByConditionForPage(map);
        int totalRows = departmentService.queryDepartmentCountOfByCondition(map);

        //根据查询结果生成相应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("departmentList",departmentList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }
}
