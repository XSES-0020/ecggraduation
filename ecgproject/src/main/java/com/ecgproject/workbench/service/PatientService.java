package com.ecgproject.workbench.service;

import com.ecgproject.workbench.domain.Patient;

import java.util.List;
import java.util.Map;

public interface PatientService {
    int saveCreatePatient(Patient patient);

    List<Patient> queryPatientByConditionForPage(Map<String,Object> map);

    int queryCountOfPatientByCondition(Map<String,Object> map);

    int deletePatientById(String id);

    Patient queryPatientById(String id);

    int saveEditPatient(Patient patient);
}
