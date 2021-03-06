package com.ecgproject.settings.mapper;

import com.ecgproject.settings.domain.Staff;

import java.util.List;
import java.util.Map;

public interface StaffMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table staff
     *
     * @mbggenerated Mon May 02 16:53:33 CST 2022
     */
    int deleteByPrimaryKey(String staffId);


    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table staff
     *
     * @mbggenerated Mon May 02 16:53:33 CST 2022
     */
    int insertSelective(Staff record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table staff
     *
     * @mbggenerated Mon May 02 16:53:33 CST 2022
     */
    Staff selectByPrimaryKey(String staffId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table staff
     *
     * @mbggenerated Mon May 02 16:53:33 CST 2022
     */
    int updateByPrimaryKeySelective(Staff record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table staff
     *
     * @mbggenerated Mon May 02 16:53:33 CST 2022
     */
    int updateByPrimaryKey(Staff record);

    /**
     * 根据工号查询是否已经注册
     */
    Staff selectById(String userId);

    /**
     * 根据工号查询
     */
    Staff selectStaffById(String staffId);

    /**
     * 更新注册状态
     */
    int updateStatusById(Map<String,Object> map);

    /**
     * 根据条件分页查询
     */
    List<Staff> selectStaffByConditionForPage(Map<String,Object> map);

    /**
     * 根据条件查询员工的总条数
     * @param map
     * @return
     */
    int selectCountOfStaffByCondition(Map<String,Object> map);

    /**
     * 添加员工
     *
     * @mbggenerated Mon May 02 16:53:33 CST 2022
     */
    int insertStaff(Staff staff);

    /**
     * 查询所有
     * @return
     */
    List<Staff> selectAllStaffs();
}