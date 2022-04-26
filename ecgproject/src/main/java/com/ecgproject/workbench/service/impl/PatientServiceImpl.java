package com.ecgproject.workbench.service.impl;

import com.ecgproject.workbench.domain.Patient;
import com.ecgproject.workbench.mapper.PatientMapper;
import com.ecgproject.workbench.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("patientService")
public class PatientServiceImpl implements PatientService {

    @Autowired
    private PatientMapper patientMapper;

    @Override
    public int saveCreatePatient(Patient patient) {
        return patientMapper.insertPatient(patient);
    }

    @Override
    public List<Patient> queryPatientByConditionForPage(Map<String, Object> map) {
        return patientMapper.selectPatientByConditionForPage(map);
    }

    @Override
    public int queryCountOfPatientByCondition(Map<String, Object> map) {
        return patientMapper.selectCountOfPatientByCondition(map);
    }

    @Override
    public int deletePatientById(String id) {
        return patientMapper.deletePatientById(id);
    }

    @Override
    public Patient queryPatientById(String id) {
        return patientMapper.selectPatientById(id);
    }

    @Override
    public int saveEditPatient(Patient patient) {
        return patientMapper.updatePatient(patient);
    }


    @Override
    public List<Patient> queryAllPatients() {
        return patientMapper.selectAllPatients();
    }
}
