package com.ecgproject.workbench.web.controller;


import com.ecgproject.commons.constants.Constants;
import com.ecgproject.commons.domain.ReturnObject;
import com.ecgproject.workbench.domain.Machine;
import com.ecgproject.workbench.domain.Machinestate;
import com.ecgproject.workbench.domain.Patient;
import com.ecgproject.workbench.service.MachineService;
import com.ecgproject.workbench.service.MachinestateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
public class MachineController {
    @Autowired
    private MachineService machineService;

    @Autowired
    private MachinestateService machinestateService;

    @RequestMapping("/workbench/machine/index.do")
    public String index(HttpServletRequest request){

        //搜所有机器状态
        List<Machinestate> machinestateList = machinestateService.queryAllMachinestates();
        request.setAttribute("machinestateList",machinestateList);

        return "workbench/machine/index";
    }

    @RequestMapping("/workbench/machine/queryMachineById.do")
    public @ResponseBody Object queryMachineById(String machineId){
        Machine machine = machineService.queryMachineById(machineId);
        return machine;
    }

    //删除机器
    @RequestMapping("/workbench/machine/deleteMachineById.do")
    public @ResponseBody Object deleteMachineById(String machineId){
        ReturnObject returnObject = new ReturnObject();

        try{
            int ret = machineService.deleteMachineById(machineId);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙碌，请稍后重试……");
            }
        }catch(Exception e){
            e.printStackTrace();

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }
        return returnObject;
    }

    //添加机器
    @RequestMapping("/workbench/machine/saveCreateMachine.do")
    public @ResponseBody Object saveCreateMachine(Machine machine){
        ReturnObject returnObject = new ReturnObject();

        try {
            //调service层保存市场活动
            int ret = machineService.saveCreateMachine(machine);

            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙碌，请稍后重试……");
            }
        } catch (Exception e) {
            e.printStackTrace();

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }

        return returnObject;
    }

    //改机器状态
    @RequestMapping("/workbench/machine/saveEditMachine.do")
    public @ResponseBody Object saveEditMachine(String machineId,String machineState){
        //这里应该用machine 但是我之前appointment功能用的map所以就这样吧来不及改了
        Map<String,Object> map = new HashMap<>();
        map.put("machineId",machineId);
        map.put("machineState",machineState);
        ReturnObject returnObject = new ReturnObject();
        try{
            //调service
            int ret = machineService.updateMachineState(map);

            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙碌，请稍后重试……");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/machine/queryMachineByConditionForPage.do")
    public @ResponseBody Object queryMachineByConditionForPage(String state,int pageNo,int pageSize){
        //封装
        Map<String,Object> map = new HashMap<>();
        map.put("machineState",state);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调service查数据
        List<Machine> machineList = machineService.queryMachineByConditionForPage(map);
        int totalRows = machineService.queryCountOfMachineByCondition(map);

        //根据查询结果生成相应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("machineList",machineList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }


}
