package com.ecgproject.workbench.service.impl;

import com.ecgproject.workbench.domain.Department;
import com.ecgproject.workbench.mapper.DepartmentMapper;
import com.ecgproject.workbench.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("departmentService")
public class DepartmentServiceImpl implements DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    @Override
    public List<Department> queryDepartmentByConditionForPage(Map<String, Object> map) {
        return departmentMapper.selectDepartmentByConditionForPage(map);
    }

    @Override
    public int queryDepartmentCountOfByCondition(Map<String, Object> map) {
        return departmentMapper.selectCountOfDepartmentByCondition(map);
    }
}
