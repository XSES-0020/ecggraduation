package com.ecgproject.settings.service.impl;

import com.ecgproject.settings.domain.Staff;
import com.ecgproject.settings.mapper.StaffMapper;
import com.ecgproject.settings.service.StaffService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("staffService")
public class StaffServiceImpl implements StaffService {

    @Autowired
    private StaffMapper staffMapper;

    @Override
    public Staff queryStaffByRegisterAct(String userId) {
        return staffMapper.selectById(userId);
    }

    @Override
    public int updateStatusById(String staffId) {
        return staffMapper.updateStatusById(staffId);
    }
}
