package com.ecgproject.workbench.mapper;

import com.ecgproject.settings.domain.User;
import com.ecgproject.workbench.domain.Patient;

import java.util.List;
import java.util.Map;

public interface PatientMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table patient
     *
     * @mbggenerated Wed Apr 13 22:50:24 CST 2022
     */
    int deleteByPrimaryKey(String patientId);


    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table patient
     *
     * @mbggenerated Wed Apr 13 22:50:24 CST 2022
     */
    int insertSelective(Patient record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table patient
     *
     * @mbggenerated Wed Apr 13 22:50:24 CST 2022
     */
    Patient selectByPrimaryKey(String patientId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table patient
     *
     * @mbggenerated Wed Apr 13 22:50:24 CST 2022
     */
    int updateByPrimaryKeySelective(Patient record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table patient
     *
     * @mbggenerated Wed Apr 13 22:50:24 CST 2022
     */
    int updateByPrimaryKey(Patient record);

    /**
     * 保存创建的患者
     * @return
     */
    int insertPatient(Patient patient);

    /**
     * 根据条件分页查询
     */
    List<Patient> selectPatientByConditionForPage(Map<String,Object> map);

    /**
     * 根据条件查询患者的总条数
     * @param map
     * @return
     */
    int selectCountOfPatientByCondition(Map<String,Object> map);

    /**
     * 删除患者
     */
    int deletePatientById(String id);

    /**
     * 查询患者信息
     */
    Patient selectPatientById(String id);

    /**
     * 保存修改的患者信息
     * @param patient
     * @return
     */
    int updatePatient(Patient patient);
}