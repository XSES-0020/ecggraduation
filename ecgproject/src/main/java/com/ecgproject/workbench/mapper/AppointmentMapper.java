package com.ecgproject.workbench.mapper;

import com.ecgproject.workbench.domain.Appointment;
import com.ecgproject.workbench.domain.BasicbarVO;
import com.ecgproject.workbench.domain.DoughnutVO;

import java.util.List;
import java.util.Map;

public interface AppointmentMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table appointment
     *
     * @mbggenerated Sun Apr 24 16:34:19 CST 2022
     */
    int deleteById(String appointmentId);


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
     * 搜索所有符合条件的预约
     */
    List<Appointment> selectAppointmentByConditionForPage(Map map);

    /**
     * 搜索所有符合条件的预约
     */
    int selectCountOfAppointmentByCondition(Map map);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table appointment
     *
     * @mbggenerated Sun Apr 24 16:34:19 CST 2022
     */
    int insertAppointment(Appointment appointment);

    /**
     * 处理预约
     * @param map
     * @return
     */
    int updateAppointmentById(Map map);

    /**
     * 单搜
     * @param appointmentId
     * @return
     */
    Appointment selectAppointmentById(String appointmentId);

    /**
     * 根据使用次数
     * @return
     */
    List<BasicbarVO> selectCountOfMachineGroupByTime();

    /**
     * 根据预约状态查询数量
     * @return
     */
    List<DoughnutVO> selectCountOfAppointmentGroupByState();
}