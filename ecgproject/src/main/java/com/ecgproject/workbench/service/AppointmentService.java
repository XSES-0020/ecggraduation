package com.ecgproject.workbench.service;

import com.ecgproject.workbench.domain.Appointment;

import java.util.List;
import java.util.Map;

public interface AppointmentService {
    //根据条件分页查询
    List<Appointment> queryAppointmentByConditionForPage(Map<String,Object> map);

    //根据条件查询符合的总数
    int queryAppointmentCountOfByCondition(Map<String,Object> map);

    //添加预约
    int saveCreateAppointment(Appointment appointment);

    //删除预约
    int deleteAppointmentById(String appointmentId);

    //处理预约
    int updateAppointmentById(Map<String,Object> map);

    //单搜
    Appointment queryAppointmentById(String appointmentId);
}
