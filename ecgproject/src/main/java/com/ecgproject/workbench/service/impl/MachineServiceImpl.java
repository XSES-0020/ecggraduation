package com.ecgproject.workbench.service.impl;

import com.ecgproject.workbench.domain.DoughnutVO;
import com.ecgproject.workbench.domain.Machine;
import com.ecgproject.workbench.mapper.MachineMapper;
import com.ecgproject.workbench.service.MachineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service("machineService")
public class MachineServiceImpl implements MachineService {
    @Autowired
    MachineMapper machineMapper;

    @Override
    public List<Machine> queryUsableMachines() {
        return machineMapper.selectUsableMachines();
    }

    @Override
    @Transactional(readOnly = false)
    public int updateMachineState(Map<String, Object> map) {
        return machineMapper.updateMachineState(map);
    }

    @Override
    public int saveCreateMachine(Machine machine) {
        return machineMapper.insertMachine(machine);
    }

    @Override
    public List<Machine> queryMachineByConditionForPage(Map<String, Object> map) {
        return machineMapper.selectMachineByConditionForPage(map);
    }

    @Override
    public int queryCountOfMachineByCondition(Map<String, Object> map) {
        return machineMapper.selectCountOfMachineByCondition(map);
    }

    @Override
    public int deleteMachineById(String machineId) {
        return machineMapper.deleteMachineById(machineId);
    }

    @Override
    public Machine queryMachineById(String machineId) {
        return machineMapper.selectByMachineId(machineId);
    }

    @Override
    public List<DoughnutVO> queryCountOfMachineGroupByState() {
        return machineMapper.selectCountOfMachineGroupByState();
    }

    @Override
    public List<Machine> queryAllMachines() {
        return machineMapper.selectAllMachines();
    }
}
