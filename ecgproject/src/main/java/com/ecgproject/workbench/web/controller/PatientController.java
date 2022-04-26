package com.ecgproject.workbench.web.controller;

import com.ecgproject.commons.constants.Constants;
import com.ecgproject.commons.domain.ReturnObject;
import com.ecgproject.settings.domain.User;
import com.ecgproject.settings.service.UserService;
import com.ecgproject.workbench.domain.Patient;
import com.ecgproject.workbench.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class PatientController {

    @Autowired
    private UserService userService;

    @Autowired
    private PatientService patientService;

    @RequestMapping("/workbench/patient/index.do")
    public String index(HttpServletRequest request){
        //调service查所有用户
        List<User> userList = userService.queryAllUsers();
        //数据放request里
        request.setAttribute("userList",userList);
        //请求转发到患者列表的主页面
        return "workbench/patient/index";
    }

    /**
     * 04/14 查询主键是否已存在还没写
     * @param patient
     * @return
     */
    @RequestMapping("/workbench/patient/saveCreatePatient.do")
    public @ResponseBody Object saveCreatePatient(Patient patient){
        //封装参数
        //patient.setId()
        patient.setPatientCreatetime(new Date());
        //activity.setCreateBy(user.id)

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service层保存市场活动
            int ret = patientService.saveCreatePatient(patient);

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

    @RequestMapping("/workbench/patient/queryPatientByConditionForPage.do")
    public @ResponseBody Object queryPatientByConditionForPage(String name,int pageNo,int pageSize){
        //封装
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调service查数据
        List<Patient> patientList = patientService.queryPatientByConditionForPage(map);
        int totalRows = patientService.queryCountOfPatientByCondition(map);

        //根据查询结果生成相应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("patientList",patientList);
        retMap.put("totalRows",totalRows);

        return retMap;

    }

    @RequestMapping("/workbench/patient/deletePatientById.do")
    public @ResponseBody Object deletePatientById(String id){
        ReturnObject returnObject = new ReturnObject();
        try{
            //调service删
            int ret = patientService.deletePatientById(id);
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

    @RequestMapping("/workbench/patient/queryPatientById.do")
    public @ResponseBody Object queryPatientById(String id){
        Patient patient = patientService.queryPatientById(id);
        return patient;
    }

    @RequestMapping("/workbench/patient/saveEditPatient.do")
    public @ResponseBody Object saveEditPatient(Patient patient){

        ReturnObject returnObject = new ReturnObject();
        try{
            //调service
            int ret = patientService.saveEditPatient(patient);

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
