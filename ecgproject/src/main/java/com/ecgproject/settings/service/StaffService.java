package com.ecgproject.settings.service;

import com.ecgproject.settings.domain.Staff;

public interface StaffService {
    Staff queryStaffByRegisterAct(String userId);

    //更新注册状态
    int updateStatusById(String staffId);
}
