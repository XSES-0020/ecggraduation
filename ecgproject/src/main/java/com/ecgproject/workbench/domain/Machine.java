package com.ecgproject.workbench.domain;

public class Machine {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column machine.machine_id
     *
     * @mbggenerated Mon Apr 25 23:26:38 CST 2022
     */
    private String machineId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column machine.machine_state
     *
     * @mbggenerated Mon Apr 25 23:26:38 CST 2022
     */
    private String machineState;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column machine.machine_id
     *
     * @return the value of machine.machine_id
     *
     * @mbggenerated Mon Apr 25 23:26:38 CST 2022
     */
    public String getMachineId() {
        return machineId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column machine.machine_id
     *
     * @param machineId the value for machine.machine_id
     *
     * @mbggenerated Mon Apr 25 23:26:38 CST 2022
     */
    public void setMachineId(String machineId) {
        this.machineId = machineId == null ? null : machineId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column machine.machine_state
     *
     * @return the value of machine.machine_state
     *
     * @mbggenerated Mon Apr 25 23:26:38 CST 2022
     */
    public String getMachineState() {
        return machineState;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column machine.machine_state
     *
     * @param machineState the value for machine.machine_state
     *
     * @mbggenerated Mon Apr 25 23:26:38 CST 2022
     */
    public void setMachineState(String machineState) {
        this.machineState = machineState == null ? null : machineState.trim();
    }
}