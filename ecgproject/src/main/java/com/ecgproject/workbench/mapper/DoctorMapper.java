package com.ecgproject.workbench.mapper;

import com.ecgproject.workbench.domain.Doctor;

import javax.print.Doc;
import java.util.List;
import java.util.Map;

public interface DoctorMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table doctor
     *
     * @mbggenerated Fri Apr 22 15:40:27 CST 2022
     */
    int deleteByPrimaryKey(String doctorId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table doctor
     *
     * @mbggenerated Fri Apr 22 15:40:27 CST 2022
     */
    int insert(Doctor record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table doctor
     *
     * @mbggenerated Fri Apr 22 15:40:27 CST 2022
     */
    int insertSelective(Doctor record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table doctor
     *
     * @mbggenerated Fri Apr 22 15:40:27 CST 2022
     */
    Doctor selectByPrimaryKey(String doctorId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table doctor
     *
     * @mbggenerated Fri Apr 22 15:40:27 CST 2022
     */
    int updateByPrimaryKeySelective(Doctor record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table doctor
     *
     * @mbggenerated Fri Apr 22 15:40:27 CST 2022
     */
    int updateByPrimaryKey(Doctor record);

    /**
     * 根据条件分页查询医生
     */
    List<Doctor> selectDoctorByConditionForPage(Map<String,Object> map);

    /**
     * 根据条件查询医生总条数
     */
    int selectCountOfDoctorByCondition(Map<String,Object> map);

    /**
     * 查询所有医生
     * @return
     */
    List<Doctor> selectAllDoctors();
}