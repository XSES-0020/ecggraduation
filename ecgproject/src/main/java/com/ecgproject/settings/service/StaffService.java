package com.ecgproject.settings.service;

import com.ecgproject.settings.domain.Staff;
import com.ecgproject.workbench.domain.Patient;

import java.util.List;
import java.util.Map;

public interface StaffService {
    Staff queryStaffByRegisterAct(String userId);

    //更新注册状态
    int updateStatusById(Map<String,Object> map);

    //根据条件分页查
    List<Staff> queryStaffByConditionForPage(Map<String,Object> map);

    //根据条件查总数
    int queryCountOfStaffByCondition(Map<String,Object> map);

    //添加员工
    int insertStaff(Staff staff);

    //更新员工
    int updateStaffById(Staff staff);

    //查找员工
    Staff selectStaffById(String staffId);

    //删除员工
    int deleteStaffById(String staffId);

    //查所有
    List<Staff> selectAllStaffs();
}
