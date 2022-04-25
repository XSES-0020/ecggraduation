package com.ecgproject.workbench.service.impl;

import com.ecgproject.workbench.domain.Order;
import com.ecgproject.workbench.mapper.OrderMapper;
import com.ecgproject.workbench.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("orderService")
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Override
    public List<Order> queryOrderByConditionForPage(Map<String, Object> map) {
        return orderMapper.selectOrderByConditionForPage(map);
    }

    @Override
    public int queryOrderCountOfByCondition(Map<String, Object> map) {
        return orderMapper.selectCountOfOrderByCondition(map);
    }
}
