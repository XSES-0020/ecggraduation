package com.ecgproject.workbench.domain;

public class Appointmentstate {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column appointmentstate.appointmentstate_id
     *
     * @mbggenerated Sun May 01 22:45:40 CST 2022
     */
    private String appointmentstateId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column appointmentstate.appointmentstate_describe
     *
     * @mbggenerated Sun May 01 22:45:40 CST 2022
     */
    private String appointmentstateDescribe;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column appointmentstate.appointmentstate_id
     *
     * @return the value of appointmentstate.appointmentstate_id
     *
     * @mbggenerated Sun May 01 22:45:40 CST 2022
     */
    public String getAppointmentstateId() {
        return appointmentstateId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column appointmentstate.appointmentstate_id
     *
     * @param appointmentstateId the value for appointmentstate.appointmentstate_id
     *
     * @mbggenerated Sun May 01 22:45:40 CST 2022
     */
    public void setAppointmentstateId(String appointmentstateId) {
        this.appointmentstateId = appointmentstateId == null ? null : appointmentstateId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column appointmentstate.appointmentstate_describe
     *
     * @return the value of appointmentstate.appointmentstate_describe
     *
     * @mbggenerated Sun May 01 22:45:40 CST 2022
     */
    public String getAppointmentstateDescribe() {
        return appointmentstateDescribe;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column appointmentstate.appointmentstate_describe
     *
     * @param appointmentstateDescribe the value for appointmentstate.appointmentstate_describe
     *
     * @mbggenerated Sun May 01 22:45:40 CST 2022
     */
    public void setAppointmentstateDescribe(String appointmentstateDescribe) {
        this.appointmentstateDescribe = appointmentstateDescribe == null ? null : appointmentstateDescribe.trim();
    }
}