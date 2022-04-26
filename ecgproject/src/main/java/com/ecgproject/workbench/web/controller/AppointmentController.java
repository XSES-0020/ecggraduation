package com.ecgproject.workbench.web.controller;

import com.ecgproject.commons.constants.Constants;
import com.ecgproject.commons.domain.ReturnObject;
import com.ecgproject.commons.utils.DateUtils;
import com.ecgproject.commons.utils.UUIDUtils;
import com.ecgproject.workbench.domain.*;
import com.ecgproject.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class AppointmentController {
    @Autowired
    private AppointmentService appointmentService;

    @Autowired
    private PatientService patientService;

    @Autowired
    private DepartmentService departmentService;

    @Autowired
    private DoctorService doctorService;

    @Autowired
    private MachineService machineService;

    @RequestMapping("/workbench/appointment/index.do")
    public String index(HttpServletRequest request) {

        //搜所有的患者
        List<Patient> patientList = patientService.queryAllPatients();
        request.setAttribute("patientList", patientList);

        //搜素所有科室
        List<Department> departmentList = departmentService.queryAllDepartments();
        request.setAttribute("departmentList", departmentList);

        //搜所有医生
        List<Doctor> doctorList = doctorService.queryAllDoctors();
        request.setAttribute("doctorList", doctorList);

        return "workbench/appointment/index";
    }

    @RequestMapping("/workbench/appointment/queryAppointmentById.do")
    public @ResponseBody Object queryAppointmentById(String appointmentId){
        Appointment appointment = appointmentService.queryAppointmentById(appointmentId);
        return appointment;
    }

    @RequestMapping("/workbench/appointment/queryAppointmentByConditionForPage.do")
    public @ResponseBody Object queryAppointmentByConditionForPage(String take, int pageNo, int pageSize) {
        //封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("status", take);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        //调service查数据
        List<Appointment> appointmentList = appointmentService.queryAppointmentByConditionForPage(map);
        int totalRows = appointmentService.queryAppointmentCountOfByCondition(map);


        //根据查询结果生成相应信息
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("appointmentList", appointmentList);
        retMap.put("totalRows", totalRows);

        return retMap;
    }

    @RequestMapping("/workbench/appointment/queryUsableMachines.do")
    public @ResponseBody Object queryUsableMachines(){
        //调service查数据
        List<Machine> machineList = machineService.queryUsableMachines();

        Map<String,Object> retMap = new HashMap<>();
        retMap.put("machineList",machineList);

        return retMap;
    }

    @RequestMapping("/workbench/appointment/dealAppointmentById.do")
    public @ResponseBody Object dealAppointmentById(String appointmentMachine,String appointmentId,String machineState,String appointmentStatus){
        //封装参数
        Map<String,Object> map2 = new HashMap<>();
        map2.put("machineId",appointmentMachine);
        map2.put("machineState",machineState);

        //改日期格式
        Map<String,Object> map1 = new HashMap<>();
        DateUtils dateUtils = new DateUtils();
        Date date = new Date();
        String appointmentTaketime = dateUtils.formateDateTime(date);
        //封装参数
        map1.put("appointmentId",appointmentId);
        map1.put("appointmentMachine",appointmentMachine);
        map1.put("appointmentTaketime",appointmentTaketime);
        map1.put("appointmentStatus",appointmentStatus);

        ReturnObject returnObject = new ReturnObject();
        try{
            //调service删
            int ret1 = appointmentService.updateAppointmentById(map1);
            int ret2 = machineService.updateMachineState(map2);
            if(ret1>0 && ret2>0){
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

    @RequestMapping("/workbench/appointment/deleteAppointmentById.do")
    public @ResponseBody Object deleteAppointmentById(String appointmentId){
        ReturnObject returnObject = new ReturnObject();
        try{
            //调service删
            int ret = appointmentService.deleteAppointmentById(appointmentId);
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

    @RequestMapping("/workbench/appointment/saveCreateAppointment.do")
    public @ResponseBody Object saveCreateAppointment(Appointment appointment) {
        //封装参数

        //改日期格式
        DateUtils dateUtils = new DateUtils();
        Date date = new Date();
        String appointmentCreatetime = dateUtils.formateDateTime(date);
        //加日期
        appointment.setAppointmentCreatetime(appointmentCreatetime);

        //加处理状态 默认未处理
        appointment.setAppointmentStatus("0");

        //加id
        UUIDUtils uuidUtils = new UUIDUtils();
        String appointmentId = uuidUtils.getUUID();
        appointment.setAppointmentId(appointmentId);

        ReturnObject returnObject = new ReturnObject();

        try {
            //调service层保存市场活动
            int ret = appointmentService.saveCreateAppointment(appointment);

            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙碌，请稍后重试……");
            }
        } catch (Exception e) {
            e.printStackTrace();

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }

        return returnObject;
    }

}