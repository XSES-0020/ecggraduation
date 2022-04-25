package com.ecgproject.workbench.service.impl;

import com.ecgproject.workbench.domain.Appointment;
import com.ecgproject.workbench.mapper.AppointmentMapper;
import com.ecgproject.workbench.service.AppointmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("appointmentService")
public class AppointmentServiceImpl implements AppointmentService {

    @Autowired
    private AppointmentMapper appointmentMapper;

    @Override
    public List<Appointment> queryAppointmentByConditionForPage(Map<String, Object> map) {
        return appointmentMapper.selectAppointmentByConditionForPage(map);
    }

    @Override
    public int queryAppointmentCountOfByCondition(Map<String, Object> map) {
        return appointmentMapper.selectCountOfAppointmentByCondition(map);
    }
}
