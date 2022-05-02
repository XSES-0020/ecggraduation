package com.ecgproject.workbench.service.impl;

import com.ecgproject.workbench.domain.Doctor;
import com.ecgproject.workbench.mapper.DoctorMapper;
import com.ecgproject.workbench.service.DoctorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("doctorService")
public class DoctorServiceImpl implements DoctorService {

    @Autowired
    private DoctorMapper doctorMapper;

    @Override
    public List<Doctor> queryDoctorByConditionForPage(Map<String, Object> map) {
        return doctorMapper.selectDoctorByConditionForPage(map);
    }

    @Override
    public int queryCountOfByCondition(Map<String, Object> map) {
        return doctorMapper.selectCountOfDoctorByCondition(map);
    }

    @Override
    public List<Doctor> queryAllDoctors() {
        return doctorMapper.selectAllDoctors();
    }

    @Override
    public int insertDoctor(Doctor doctor) {
        return doctorMapper.insert(doctor);
    }

    @Override
    public Doctor selectDoctorById(String doctorId) {
        return doctorMapper.selectByPrimaryKey(doctorId);
    }

    @Override
    public int updateDoctor(Doctor doctor) {
        return doctorMapper.updateByPrimaryKey(doctor);
    }
}
