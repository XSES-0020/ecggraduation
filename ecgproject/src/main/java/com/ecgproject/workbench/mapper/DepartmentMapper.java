package com.ecgproject.workbench.mapper;

import com.ecgproject.workbench.domain.Department;

import java.util.List;
import java.util.Map;

public interface DepartmentMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table department
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    int deleteByPrimaryKey(String departmentId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table department
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    int insert(Department record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table department
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    int insertSelective(Department record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table department
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    Department selectByPrimaryKey(String departmentId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table department
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    int updateByPrimaryKeySelective(Department record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table department
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    int updateByPrimaryKey(Department record);

    /**
     * 根据条件分页查询科室
     */
    List<Department> selectDepartmentByConditionForPage(Map<String,Object> map);

    /**
     * 根据条件查询科室总条数
     */
    int selectCountOfDepartmentByCondition(Map<String,Object> map);

    /**
     * 查询所有科室
     * @return
     */
    List<Department> selectAllDepartments();
}