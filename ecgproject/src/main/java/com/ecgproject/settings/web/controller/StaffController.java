package com.ecgproject.settings.web.controller;

import com.ecgproject.commons.constants.Constants;
import com.ecgproject.commons.domain.ReturnObject;
import com.ecgproject.settings.domain.Staff;
import com.ecgproject.settings.domain.User;
import com.ecgproject.settings.service.StaffService;
import com.ecgproject.settings.service.UserService;
import com.ecgproject.workbench.domain.Patient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class StaffController {

    @Autowired
    private StaffService staffService;

    @Autowired
    private UserService userService;

    @RequestMapping("/workbench/staff/staffAdmin.do")
    public String index(){
        return "workbench/staff/staffAdmin";
    }

    @RequestMapping("/workbench/staff/queryStaffById.do")
    public @ResponseBody Object queryStaffById(String staffId){
        Staff staff = staffService.selectStaffById(staffId);
        return staff;
    }

    /**
     * 更新
     * @param staff
     * @return
     */
    @RequestMapping("/workbench/staff/saveEditStaff.do")
    public @ResponseBody Object saveEditPatient(Staff staff){

        ReturnObject returnObject = new ReturnObject();
        try{
            //调service
            int ret = staffService.updateStaffById(staff);

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

    /**
     * 如果注册了的话，还得把user表里的也删了
     * @param staffId
     * @return
     */
    @RequestMapping("/workbench/staff/deleteStaffById.do")
    public @ResponseBody Object deleteStaffById(String staffId){

        ReturnObject returnObject = new ReturnObject();
        try{
            Staff staff = staffService.selectStaffById(staffId);
            if(staff.getStaffStatus().equals("1")){
                //如果staff注册了的话，就得把这个用户一起删掉
                int ret1 = staffService.deleteStaffById(staffId);
                int ret2 = userService.deleteUserById(staffId);

                if(ret1>0&&ret2>0){
                    returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                }else{
                    returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("系统忙碌，请稍后重试……");
                }
            }else{
                int ret1 = staffService.deleteStaffById(staffId);
                if(ret1>0){
                    returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                }else{
                    returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("系统忙碌，请稍后重试……");
                }
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }

        return returnObject;
    }

    /**
     * 添加员工
     * @param staff
     * @return
     */
    @RequestMapping("/workbench/patient/saveCreateStaff.do")
    public @ResponseBody Object saveCreateStaff(Staff staff){
        //封装参数
        //patient.setId()
        staff.setStaffStatus("0");

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service层保存市场活动
            int ret = staffService.insertStaff(staff);

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

    @RequestMapping("/workbench/staff/queryStaffByConditionForPage.do")
    public @ResponseBody Object queryStaffByConditionForPage(String name,String id,String state,int pageNo,int pageSize){
        //封装
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("id",id);
        map.put("state",state);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调service查数据
        List<Staff> staffList = staffService.queryStaffByConditionForPage(map);
        int totalRows = staffService.queryCountOfStaffByCondition(map);

        //根据查询结果生成相应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("staffList",staffList);
        retMap.put("totalRows",totalRows);

        return retMap;

    }
}
