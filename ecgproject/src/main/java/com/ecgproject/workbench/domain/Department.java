package com.ecgproject.workbench.domain;

public class Department {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column department.department_id
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    private String departmentId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column department.department_name
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    private String departmentName;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column department.department_address
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    private String departmentAddress;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column department.department_id
     *
     * @return the value of department.department_id
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    public String getDepartmentId() {
        return departmentId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column department.department_id
     *
     * @param departmentId the value for department.department_id
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    public void setDepartmentId(String departmentId) {
        this.departmentId = departmentId == null ? null : departmentId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column department.department_name
     *
     * @return the value of department.department_name
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    public String getDepartmentName() {
        return departmentName;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column department.department_name
     *
     * @param departmentName the value for department.department_name
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName == null ? null : departmentName.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column department.department_address
     *
     * @return the value of department.department_address
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    public String getDepartmentAddress() {
        return departmentAddress;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column department.department_address
     *
     * @param departmentAddress the value for department.department_address
     *
     * @mbggenerated Sat Apr 23 14:39:47 CST 2022
     */
    public void setDepartmentAddress(String departmentAddress) {
        this.departmentAddress = departmentAddress == null ? null : departmentAddress.trim();
    }
}