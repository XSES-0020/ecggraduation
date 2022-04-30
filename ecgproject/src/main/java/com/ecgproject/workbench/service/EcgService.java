package com.ecgproject.workbench.service;

import com.ecgproject.workbench.domain.Ecg;
import com.ecgproject.workbench.domain.Patient;

import java.util.List;
import java.util.Map;

public interface EcgService {
    //添加
    int saveImportEcg(Ecg ecg);

    //查分页
    List<Ecg> queryEcgByConditionForPage(Map<String,Object> map);

    //查总数
    int queryCountOfEcgByCondition(Map<String,Object> map);
}
