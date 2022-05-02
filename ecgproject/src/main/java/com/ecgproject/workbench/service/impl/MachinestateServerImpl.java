package com.ecgproject.workbench.service.impl;

import com.ecgproject.workbench.domain.Machinestate;
import com.ecgproject.workbench.mapper.MachinestateMapper;
import com.ecgproject.workbench.service.MachineService;
import com.ecgproject.workbench.service.MachinestateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("machinestateService")
public class MachinestateServerImpl implements MachinestateService {

    @Autowired
    private MachinestateMapper machinestateMapper;

    @Override
    public List<Machinestate> queryAllMachinestates() {
        return machinestateMapper.selectAllMachinestate();
    }
}
