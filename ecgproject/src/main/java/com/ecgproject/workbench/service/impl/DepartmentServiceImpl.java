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

    @Override
    public List<Department> queryAllDepartments() {
        return departmentMapper.selectAllDepartments();
    }

    @Override
    public int insertDepartment(Department department) {
        return departmentMapper.insert(department);
    }

    @Override
    public int updateDepartment(Department department) {
        return departmentMapper.updateByPrimaryKey(department);
    }

    @Override
    public Department queryDepartmentById(String departmentId) {
        return departmentMapper.selectByPrimaryKey(departmentId);
    }

    @Override
    public int deleteDepartmentById(String departmentId) {
        return departmentMapper.deleteByPrimaryKey(departmentId);
    }
}
