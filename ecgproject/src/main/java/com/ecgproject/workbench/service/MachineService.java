package com.ecgproject.workbench.service;

import com.ecgproject.workbench.domain.DoughnutVO;
import com.ecgproject.workbench.domain.Machine;

import javax.crypto.Mac;
import java.util.List;
import java.util.Map;

public interface MachineService {
    //查询所有可用
    List<Machine> queryUsableMachines();

    //更改机器状态
    int updateMachineState(Map<String,Object> map);

    //添加
    int saveCreateMachine(Machine machine);

    //查询
    List<Machine> queryMachineByConditionForPage(Map<String,Object> map);

    //查总数
    int queryCountOfMachineByCondition(Map<String,Object> map);

    //删
    int deleteMachineById(String machineId);

    //单查
    Machine queryMachineById(String machineId);

    //查各个状态的机器数
    List<DoughnutVO> queryCountOfMachineGroupByState();
}
