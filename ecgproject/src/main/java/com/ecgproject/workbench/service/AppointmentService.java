package com.ecgproject.workbench.service;

import com.ecgproject.workbench.domain.Appointment;

import java.util.List;
import java.util.Map;

public interface AppointmentService {
    //根据条件分页查询
    List<Appointment> queryAppointmentByConditionForPage(Map<String,Object> map);

    //根据条件查询符合的总数
    int queryAppointmentCountOfByCondition(Map<String,Object> map);
}
