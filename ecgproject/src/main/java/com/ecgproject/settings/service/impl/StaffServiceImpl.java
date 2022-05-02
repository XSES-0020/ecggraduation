package com.ecgproject.settings.service.impl;

import com.ecgproject.settings.domain.Staff;
import com.ecgproject.settings.mapper.StaffMapper;
import com.ecgproject.settings.service.StaffService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("staffService")
public class StaffServiceImpl implements StaffService {

    @Autowired
    private StaffMapper staffMapper;

    @Override
    public Staff queryStaffByRegisterAct(String userId) {
        return staffMapper.selectById(userId);
    }

    @Override
    public Staff selectStaffById(String staffId) {
        return staffMapper.selectById(staffId);
    }

    @Override
    public int updateStatusById(Map<String,Object> map) {
        return staffMapper.updateStatusById(map);
    }

    @Override
    public List<Staff> queryStaffByConditionForPage(Map<String, Object> map) {
        return staffMapper.selectStaffByConditionForPage(map);
    }

    @Override
    public int queryCountOfStaffByCondition(Map<String, Object> map) {
        return staffMapper.selectCountOfStaffByCondition(map);
    }

    @Override
    public int insertStaff(Staff staff) {
        return staffMapper.insertStaff(staff);
    }

    @Override
    public int updateStaffById(Staff staff) {
        return staffMapper.updateByPrimaryKey(staff);
    }

    @Override
    public int deleteStaffById(String staffId) {
        return staffMapper.deleteByPrimaryKey(staffId);
    }

    @Override
    public List<Staff> selectAllStaffs() {
        return staffMapper.selectAllStaffs();
    }
}
