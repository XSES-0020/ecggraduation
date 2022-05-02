package com.ecgproject.workbench.service.impl;

import com.ecgproject.workbench.domain.Appointment;
import com.ecgproject.workbench.domain.BasicbarVO;
import com.ecgproject.workbench.domain.DoughnutVO;
import com.ecgproject.workbench.mapper.AppointmentMapper;
import com.ecgproject.workbench.service.AppointmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    @Override
    public int saveCreateAppointment(Appointment appointment) {
        return appointmentMapper.insertAppointment(appointment);
    }

    @Override
    public int deleteAppointmentById(String appointmentId) {
        return appointmentMapper.deleteById(appointmentId);
    }

    @Override
    @Transactional(readOnly = false)
    public int updateAppointmentById(Map<String, Object> map) {
        return appointmentMapper.updateAppointmentById(map);
    }

    @Override
    public Appointment queryAppointmentById(String appointmentId) {
        return appointmentMapper.selectAppointmentById(appointmentId);
    }

    @Override
    public List<BasicbarVO> queryCountOfMachineGroupByTime() {
        return appointmentMapper.selectCountOfMachineGroupByTime();
    }

    @Override
    public List<DoughnutVO> queryCountOfAppointmentGroupByState() {
        return appointmentMapper.selectCountOfAppointmentGroupByState();
    }
}
