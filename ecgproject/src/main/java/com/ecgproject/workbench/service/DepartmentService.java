package com.ecgproject.workbench.service;

import com.ecgproject.workbench.domain.Department;

import java.util.List;
import java.util.Map;

public interface DepartmentService {
    //根据条件分页查询医生
    List<Department> queryDepartmentByConditionForPage(Map<String,Object> map);

    //根据条件查询符合的医生总数
    int queryDepartmentCountOfByCondition(Map<String,Object> map);

    //查所有
    List<Department> queryAllDepartments();
}
