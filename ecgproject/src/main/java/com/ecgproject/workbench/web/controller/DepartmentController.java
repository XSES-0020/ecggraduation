package com.ecgproject.workbench.web.controller;

import com.ecgproject.commons.constants.Constants;
import com.ecgproject.commons.domain.ReturnObject;
import com.ecgproject.settings.domain.Staff;
import com.ecgproject.workbench.domain.Department;
import com.ecgproject.workbench.domain.Doctor;
import com.ecgproject.workbench.domain.Patient;
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


    @RequestMapping("/workbench/department/departmentAdmin.do")
    public String departmentAdmin(){
        return "workbench/department/departmentAdmin";
    }

    //查
    @RequestMapping("/workbench/department/queryDepartmentById.do")
    public @ResponseBody Object queryDepartmentById(String id){
        Department department = departmentService.queryDepartmentById(id);
        return department;
    }

    //改
    @RequestMapping("/workbench/department/saveEditDepartment.do")
    public @ResponseBody Object saveEditDepartment(Department department){

        ReturnObject returnObject = new ReturnObject();
        try{
            //调service
            int ret = departmentService.updateDepartment(department);

            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙碌，请稍后重试……");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }

        return returnObject;
    }

    //增
    @RequestMapping("/workbench/department/saveCreateDepartment.do")
    public @ResponseBody Object saveCreateDepartment(Department department){
        //封装参数
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service层保存市场活动
            int ret = departmentService.insertDepartment(department);

            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙碌，请稍后重试……");
            }
        }catch (Exception e){
            e.printStackTrace();

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }
        return returnObject;
    }

    //查
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

    //删
    @RequestMapping("/workbench/department/deleteDepartmentById.do")
    public @ResponseBody Object deleteDepartmentById(String id){
        ReturnObject returnObject = new ReturnObject();
        try{
            //调service删
            int ret = departmentService.deleteDepartmentById(id);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙碌，请稍后重试……");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }
        return returnObject;
    }
}
