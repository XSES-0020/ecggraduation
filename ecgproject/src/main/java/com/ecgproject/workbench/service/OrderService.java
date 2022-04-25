package com.ecgproject.workbench.service;

import com.ecgproject.workbench.domain.Order;

import java.util.List;
import java.util.Map;

public interface OrderService {
    //根据条件分页查询医生
    List<Order> queryOrderByConditionForPage(Map<String,Object> map);

    //根据条件查询符合的医生总数
    int queryOrderCountOfByCondition(Map<String,Object> map);
}
