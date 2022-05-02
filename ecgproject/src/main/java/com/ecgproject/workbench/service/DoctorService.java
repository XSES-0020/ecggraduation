package com.ecgproject.workbench.service;

import com.ecgproject.workbench.domain.Doctor;

import javax.print.Doc;
import java.util.List;
import java.util.Map;

public interface DoctorService {

    //根据条件分页查询医生
    List<Doctor> queryDoctorByConditionForPage(Map<String,Object> map);

    //根据条件查询符合的医生总数
    int queryCountOfByCondition(Map<String,Object> map);

    //查询所有
    List<Doctor> queryAllDoctors();

    //存
    int insertDoctor(Doctor doctor);

    //查
    Doctor selectDoctorById(String doctorId);

    //改
    int updateDoctor(Doctor doctor);
}
