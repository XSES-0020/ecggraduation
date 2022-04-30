package com.ecgproject.workbench.service.impl;

import com.ecgproject.workbench.domain.Ecg;
import com.ecgproject.workbench.domain.Patient;
import com.ecgproject.workbench.mapper.EcgMapper;
import com.ecgproject.workbench.service.EcgService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("ecgService")
public class EcgServiceImpl implements EcgService {
    @Autowired
    private EcgMapper ecgMapper;

    @Override
    public int saveImportEcg(Ecg ecg) {
        return ecgMapper.insertEcg(ecg);
    }

    @Override
    public List<Ecg> queryEcgByConditionForPage(Map<String, Object> map) {
        return ecgMapper.selectEcgByConditionForPage(map);
    }

    @Override
    public int queryCountOfEcgByCondition(Map<String, Object> map) {
        return ecgMapper.selectCountOfEcgByCondition(map);
    }
}
