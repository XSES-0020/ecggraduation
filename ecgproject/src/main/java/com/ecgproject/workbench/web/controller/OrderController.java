package com.ecgproject.workbench.web.controller;

import com.ecgproject.workbench.domain.Department;
import com.ecgproject.workbench.domain.Order;
import com.ecgproject.workbench.service.OrderService;
import org.aspectj.weaver.ast.Or;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class OrderController {

    @Autowired
    private OrderService orderService;

    @RequestMapping("/workbench/order/index.do")
    public String index(){
        return "workbench/order/index";
    }

    @RequestMapping("/workbench/order/queryOrderByConditionForPage.do")
    public @ResponseBody Object queryOrderByConditionForPage(String take, int pageNo, int pageSize){
        //调试
        System.out.println("******************************");
        System.out.println(pageNo);
        System.out.println("******************************");

        //封装参数
        Map<String,Object> map = new HashMap<>();
        if(take=="1"){
            map.put("take",1);
        }else if(take=="0"){
            map.put("take",0);
        }else{
            map.put("take",2);
        }
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调service查数据
        List<Order> orderList = orderService.queryOrderByConditionForPage(map);
        int totalRows = orderService.queryOrderCountOfByCondition(map);

        //根据查询结果生成相应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("orderList",orderList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }
}
