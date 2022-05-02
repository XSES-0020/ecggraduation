package com.ecgproject.workbench.web.controller;

import com.ecgproject.workbench.domain.BasicbarVO;
import com.ecgproject.workbench.domain.DoughnutVO;
import com.ecgproject.workbench.domain.Machine;
import com.ecgproject.workbench.service.AppointmentService;
import com.ecgproject.workbench.service.MachineService;
import com.google.protobuf.Internal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

@Controller
public class ChartController {

    @Autowired
    private MachineService machineService;

    @Autowired
    private AppointmentService appointmentService;


    @RequestMapping("/workbench/chart/machine/index.do")
    public String indexmachine(){
        //跳转页面
        return "workbench/chart/machine/index";
    }

    @RequestMapping("/workbench/chart/appointment/index.do")
    public String indexappointment(){
        return "workbench/chart/appointment/index";
    }

    @RequestMapping("/workbench/chart/machine/queryCountOfMachineGroupByState.do")
    public @ResponseBody Object queryCountOfMachineGroupByState(){
        List<DoughnutVO> doughnutVOList = machineService.queryCountOfMachineGroupByState();
        return doughnutVOList;
    }

    @RequestMapping("/workbench/chart/appointment/queryCountOfAppointmentGroupByState.do")
    public @ResponseBody Object queryCountOfAppointmentGroupByState(){
        List<DoughnutVO> doughnutVOList = appointmentService.queryCountOfAppointmentGroupByState();
        return doughnutVOList;
    }

    @RequestMapping("/workbench/chart/machine/queryCountOfMachineGroupByTime.do")
    public @ResponseBody Object queryCountOfMachineGroupByTime(){
        List<BasicbarVO> basicbarVOList = appointmentService.queryCountOfMachineGroupByTime();
        Map<String,Object> map = new HashMap<>();

        List<String> xAxis = new ArrayList<>();
        List<Integer> series = new ArrayList<>();

        Iterator it = basicbarVOList.iterator();
        while(it.hasNext()){
            BasicbarVO basicbarVO = (BasicbarVO)it.next();
            xAxis.add(basicbarVO.getxAxis());
            series.add(basicbarVO.getSeries());
        }

        /**
         * 把没用过的机器加进去
         */
        List<Machine> machineList = machineService.queryAllMachines();
        Iterator machineIt = machineList.iterator();
        while(machineIt.hasNext()){
            Machine machine = (Machine)machineIt.next();
            String machineId = machine.getMachineId();
            if(!xAxis.contains(machineId)){
                xAxis.add(machineId);
                series.add(0);
            }
        }

        List<String> xAxisret = new ArrayList<>();
        List<Integer> seriesret = new ArrayList<>();

        Iterator xAxisIt = xAxis.iterator();
        Iterator seriesIt = series.iterator();

        int j = 0;
        int k = 0;

        while (xAxisIt.hasNext()){
            String str = (String)xAxisIt.next();
            xAxisret.add(str);
            j++;
            if(j==5){
                break;
            }
        }

        while (seriesIt.hasNext()){
            Integer in = (Integer)seriesIt.next();
            seriesret.add(in);
            k++;
            if(k==5){
                break;
            }
        }

        map.put("xAxis",xAxisret);
        map.put("series",seriesret);

        return map;
    }

}
