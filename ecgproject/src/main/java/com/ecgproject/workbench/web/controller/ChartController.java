package com.ecgproject.workbench.web.controller;

import com.ecgproject.workbench.domain.DoughnutVO;
import com.ecgproject.workbench.service.MachineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ChartController {

    @Autowired
    private MachineService machineService;

    @RequestMapping("/workbench/chart/machine/index.do")
    public String index(){
        //跳转页面
        return "workbench/chart/machine/index";
    }

    @RequestMapping("/workbench/chart/machine/queryCountOfMachineGroupByState.do")
    public @ResponseBody Object queryCountOfMachineGroupByState(){
        List<DoughnutVO> doughnutVOList = machineService.queryCountOfMachineGroupByState();
        return doughnutVOList;
    }

}
