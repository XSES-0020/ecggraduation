package com.ecgproject.workbench.domain;

public class Ecg {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column ecg.ecg_id
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    private String ecgId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column ecg.ecg_url
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    private String ecgUrl;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column ecg.ecg_uploadtime
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    private String ecgUploadtime;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column ecg.ecg_uploader
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    private String ecgUploader;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column ecg.ecg_patient
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    private String ecgPatient;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column ecg.ecg_id
     *
     * @return the value of ecg.ecg_id
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    public String getEcgId() {
        return ecgId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column ecg.ecg_id
     *
     * @param ecgId the value for ecg.ecg_id
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    public void setEcgId(String ecgId) {
        this.ecgId = ecgId == null ? null : ecgId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column ecg.ecg_url
     *
     * @return the value of ecg.ecg_url
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    public String getEcgUrl() {
        return ecgUrl;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column ecg.ecg_url
     *
     * @param ecgUrl the value for ecg.ecg_url
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    public void setEcgUrl(String ecgUrl) {
        this.ecgUrl = ecgUrl == null ? null : ecgUrl.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column ecg.ecg_uploadtime
     *
     * @return the value of ecg.ecg_uploadtime
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    public String getEcgUploadtime() {
        return ecgUploadtime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column ecg.ecg_uploadtime
     *
     * @param ecgUploadtime the value for ecg.ecg_uploadtime
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    public void setEcgUploadtime(String ecgUploadtime) {
        this.ecgUploadtime = ecgUploadtime == null ? null : ecgUploadtime.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column ecg.ecg_uploader
     *
     * @return the value of ecg.ecg_uploader
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    public String getEcgUploader() {
        return ecgUploader;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column ecg.ecg_uploader
     *
     * @param ecgUploader the value for ecg.ecg_uploader
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    public void setEcgUploader(String ecgUploader) {
        this.ecgUploader = ecgUploader == null ? null : ecgUploader.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column ecg.ecg_patient
     *
     * @return the value of ecg.ecg_patient
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    public String getEcgPatient() {
        return ecgPatient;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column ecg.ecg_patient
     *
     * @param ecgPatient the value for ecg.ecg_patient
     *
     * @mbggenerated Fri Apr 29 22:16:49 CST 2022
     */
    public void setEcgPatient(String ecgPatient) {
        this.ecgPatient = ecgPatient == null ? null : ecgPatient.trim();
    }
}