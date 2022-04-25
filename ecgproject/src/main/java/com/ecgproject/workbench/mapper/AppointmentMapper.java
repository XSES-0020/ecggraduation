package com.ecgproject.workbench.mapper;

import com.ecgproject.workbench.domain.Appointment;

import java.util.List;
import java.util.Map;

public interface AppointmentMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table appointment
     *
     * @mbggenerated Sun Apr 24 16:34:19 CST 2022
     */
    int deleteByPrimaryKey(String appointmentId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table appointment
     *
     * @mbggenerated Sun Apr 24 16:34:19 CST 2022
     */
    int insert(Appointment record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table appointment
     *
     * @mbggenerated Sun Apr 24 16:34:19 CST 2022
     */
    int insertSelective(Appointment record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table appointment
     *
     * @mbggenerated Sun Apr 24 16:34:19 CST 2022
     */
    Appointment selectByPrimaryKey(String appointmentId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table appointment
     *
     * @mbggenerated Sun Apr 24 16:34:19 CST 2022
     */
    int updateByPrimaryKeySelective(Appointment record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table appointment
     *
     * @mbggenerated Sun Apr 24 16:34:19 CST 2022
     */
    int updateByPrimaryKey(Appointment record);

    /**
     *
     */
    List<Appointment> selectAppointmentByConditionForPage(Map map);

    /**
     *
     */
    int selectCountOfAppointmentByCondition(Map map);
}