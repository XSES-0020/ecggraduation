package com.ecgproject.workbench.web.controller;

import com.ecgproject.commons.constants.Constants;
import com.ecgproject.commons.domain.ReturnObject;
import com.ecgproject.settings.domain.Staff;
import com.ecgproject.settings.domain.User;
import com.ecgproject.settings.service.StaffService;
import com.ecgproject.settings.service.UserService;
import com.ecgproject.workbench.domain.Department;
import com.ecgproject.workbench.domain.Doctor;
import com.ecgproject.workbench.domain.Patient;
import com.ecgproject.workbench.service.DepartmentService;
import com.ecgproject.workbench.service.DoctorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.print.Doc;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class DoctorController {

    @Autowired
    private DoctorService doctorService;

    @Autowired
    private UserService userService;

    @Autowired
    private StaffService staffService;

    @Autowired
    private DepartmentService departmentService;

    @RequestMapping("/workbench/doctor/index.do")
    public String index(HttpServletRequest request){
        //调service查所有用户
        List<User> userList = userService.queryAllUsers();
        //数据放request里
        request.setAttribute("userList",userList);
        //请求转发到患者列表的主页面
        return "workbench/doctor/index";
    }

    @RequestMapping("/workbench/doctor/doctorAdmin.do")
    public String doctorAdmin(HttpServletRequest request){
        //调service查所有用户
        List<User> userList = userService.queryAllUsers();
        List<Staff> staffList = staffService.selectAllStaffs();
        List<Department> departmentList = departmentService.queryAllDepartments();
        //数据放request里
        request.setAttribute("userList",userList);
        request.setAttribute("staffList",staffList);
        request.setAttribute("departmentList",departmentList);

        //请求转发到患者列表的主页面
        return "workbench/doctor/doctorAdmin";
    }


    //查
    @RequestMapping("/workbench/doctor/queryDoctorById.do")
    public @ResponseBody Object queryDepartmentById(String id){
        Doctor doctor = doctorService.selectDoctorById(id);
        return doctor;
    }

    //改
    @RequestMapping("/workbench/doctor/saveEditDoctor.do")
    public @ResponseBody Object saveEditDoctor(Doctor doctor){
        //封装参数
        Staff staff = staffService.selectStaffById(doctor.getDoctorId());
        doctor.setDoctorName(staff.getStaffName());
        if(doctor.getDoctorGender().equals("1")){
            //女的
            doctor.setDoctorGender(1);
        }else{
            doctor.setDoctorGender(0);
        }
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service层保存市场活动
            int ret = doctorService.updateDoctor(doctor);

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
    @RequestMapping("/workbench/doctor/saveCreateDoctor.do")
    public @ResponseBody Object saveCreateDoctor(Doctor doctor){
        //封装参数
        Staff staff = staffService.selectStaffById(doctor.getDoctorId());
        doctor.setDoctorName(staff.getStaffName());
        if(doctor.getDoctorGender().equals("1")){
            //女的
            doctor.setDoctorGender(1);
        }else{
            doctor.setDoctorGender(0);
        }
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service层保存市场活动
            int ret = doctorService.insertDoctor(doctor);

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
